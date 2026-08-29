import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../core/config/app_config.dart';
import '../../domain/models/direction.dart';
import '../../domain/models/phone_action.dart';
import '../../domain/navigation/phone_action_registry.dart';
import '../../domain/services/action_pipeline.dart';
import '../../platform/phone_control_platform.dart';
import '../../platform/phone_control_service.dart';
import '../providers/auth_provider.dart';

class PhoneExecutionLog {
  const PhoneExecutionLog({
    required this.action,
    required this.success,
    required this.timestamp,
    this.text,
    this.source,
  });

  final PhoneAction action;
  final bool success;
  final DateTime timestamp;
  final String? text;
  final String? source;
}

class PhoneControlState {
  const PhoneControlState({
    this.accessibilityEnabled = false,
    this.directMode = true,
    this.remoteConnected = false,
    this.deviceId = '',
    this.logs = const [],
    this.lastResult,
    this.isExecuting = false,
    this.pendingActions = 0,
  });

  final bool accessibilityEnabled;
  final bool directMode;
  final bool remoteConnected;
  final String deviceId;
  final List<PhoneExecutionLog> logs;
  final PhoneExecutionLog? lastResult;
  final bool isExecuting;
  final int pendingActions;

  PhoneControlState copyWith({
    bool? accessibilityEnabled,
    bool? directMode,
    bool? remoteConnected,
    String? deviceId,
    List<PhoneExecutionLog>? logs,
    PhoneExecutionLog? lastResult,
    bool? isExecuting,
    int? pendingActions,
  }) {
    return PhoneControlState(
      accessibilityEnabled: accessibilityEnabled ?? this.accessibilityEnabled,
      directMode: directMode ?? this.directMode,
      remoteConnected: remoteConnected ?? this.remoteConnected,
      deviceId: deviceId ?? this.deviceId,
      logs: logs ?? this.logs,
      lastResult: lastResult ?? this.lastResult,
      isExecuting: isExecuting ?? this.isExecuting,
      pendingActions: pendingActions ?? this.pendingActions,
    );
  }
}

final phoneControlServiceProvider = Provider<PhoneControlService>((ref) {
  return createPhoneControlService();
});

final phoneControlProvider =
    NotifierProvider<PhoneControlNotifier, PhoneControlState>(
  PhoneControlNotifier.new,
);

class PhoneControlNotifier extends Notifier<PhoneControlState> {
  static const _uuid = Uuid();
  late PhoneControlService _service;
  final ActionPipeline _pipeline = ActionPipeline();
  Timer? _accessibilityPollTimer;

  @override
  PhoneControlState build() {
    _service = ref.read(phoneControlServiceProvider);
    ref.onDispose(() => _accessibilityPollTimer?.cancel());
    unawaited(_refreshAccessibility());
    return PhoneControlState(deviceId: _uuid.v4());
  }

  Future<void> _refreshAccessibility() async {
    try {
      final enabled = await _service.isAccessibilityEnabled();
      state = state.copyWith(accessibilityEnabled: enabled);
    } catch (_) {
      state = state.copyWith(accessibilityEnabled: false);
    }
  }

  Future<void> openAccessibilitySettings() async {
    try {
      await _service.openAccessibilitySettings();
    } catch (_) {}
    _accessibilityPollTimer?.cancel();
    _accessibilityPollTimer = Timer.periodic(
      Duration(milliseconds: AppConfig.accessibilityPollMs),
      (_) => _refreshAccessibility(),
    );
  }

  void setDirectMode(bool enabled) {
    state = state.copyWith(directMode: enabled);
  }

  void setRemoteConnected(bool connected) {
    state = state.copyWith(remoteConnected: connected);
  }

  Future<bool> executeAction(
    PhoneAction action, {
    String? text,
    String source = 'local',
    String? dedupeKey,
  }) async {
    if (!state.accessibilityEnabled) {
      await _refreshAccessibility();
    }

    state = state.copyWith(
      isExecuting: true,
      pendingActions: state.pendingActions + 1,
    );

    final success = await _pipeline.run(
      action: action,
      dedupeKey: dedupeKey,
      execute: () => _service.execute(action, text: text),
    );

    final log = PhoneExecutionLog(
      action: action,
      success: success,
      timestamp: DateTime.now(),
      text: text,
      source: source,
    );

    state = state.copyWith(
      logs: [log, ...state.logs.take(AppConfig.maxExecutionLogs - 1)],
      lastResult: log,
      isExecuting: false,
      pendingActions: (state.pendingActions - 1).clamp(0, 999),
    );

    final bubbleMsg = success ? '${action.label} ✓' : '${action.label} failed';
    unawaited(ref.read(platformServiceProvider).updateBubbleMessage(bubbleMsg));

    return success;
  }

  Future<bool> executeFromDirection(
    Direction direction, {
    String source = 'ai',
  }) async {
    return executeAction(
      PhoneAction.fromDirection(direction),
      source: source,
      dedupeKey: 'dir_${direction.name}',
    );
  }

  Future<bool> executeFromCell(
    String cellId, {
    String source = 'matrix',
  }) async {
    final action = PhoneActionRegistry.actionForCell(cellId);
    if (action == null) return false;
    final text = PhoneActionRegistry.textForCell(cellId);
    return executeAction(action, text: text, source: source);
  }
}
