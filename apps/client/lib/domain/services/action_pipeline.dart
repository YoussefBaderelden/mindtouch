import 'dart:async';
import 'dart:collection';

import '../../core/config/app_config.dart';
import '../models/phone_action.dart';

/// Serialized, throttled action pipeline — prevents flooding the OS layer.
class ActionPipeline {
  ActionPipeline({
    this.minInterval = const Duration(milliseconds: AppConfig.actionMinIntervalMs),
    this.maxQueueSize = AppConfig.maxActionQueueSize,
  });

  final Duration minInterval;
  final int maxQueueSize;

  final Queue<_QueuedItem> _queue = Queue();
  bool _draining = false;
  DateTime? _lastRunAt;
  PhoneAction? _lastAction;
  DateTime? _lastDuplicateAt;

  Future<bool> run({
    required PhoneAction action,
    required Future<bool> Function() execute,
    String? dedupeKey,
  }) {
    final completer = Completer<bool>();
    final key = dedupeKey ?? action.id;
    final now = DateTime.now();

    if (_lastAction == action &&
        _lastDuplicateAt != null &&
        now.difference(_lastDuplicateAt!) <
            Duration(milliseconds: AppConfig.directionDebounceMs)) {
      return Future.value(true);
    }

    if (_queue.length >= maxQueueSize) {
      _queue.removeFirst();
    }

    _queue.add(_QueuedItem(action: action, key: key, execute: execute, completer: completer));
    _drain();
    return completer.future;
  }

  void clear() {
    while (_queue.isNotEmpty) {
      _queue.removeFirst().completer.complete(false);
    }
  }

  Future<void> _drain() async {
    if (_draining) return;
    _draining = true;

    while (_queue.isNotEmpty) {
      final item = _queue.removeFirst();

      if (_lastRunAt != null) {
        final wait = minInterval - DateTime.now().difference(_lastRunAt!);
        if (wait > Duration.zero) {
          await Future<void>.delayed(wait);
        }
      }

      bool success = false;
      try {
        success = await item.execute();
      } catch (_) {
        success = false;
      }

      _lastRunAt = DateTime.now();
      _lastAction = item.action;
      _lastDuplicateAt = DateTime.now();
      item.completer.complete(success);
    }

    _draining = false;
  }
}

class _QueuedItem {
  _QueuedItem({
    required this.action,
    required this.key,
    required this.execute,
    required this.completer,
  });

  final PhoneAction action;
  final String key;
  final Future<bool> Function() execute;
  final Completer<bool> completer;
}
