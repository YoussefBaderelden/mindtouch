import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../core/config/app_config.dart';
import '../../presentation/providers/auth_provider.dart';
import '../../presentation/providers/phone_control_provider.dart';

/// Cloud + local remote control — HTTP polling for Vercel and local API.
class RemoteControlService {
  RemoteControlService(this.ref);

  final Ref ref;
  Timer? _pollTimer;
  bool _disposed = false;
  bool _polling = false;
  String? _activeDeviceId;

  Future<void> connect({String? apiBase}) async {
    if (_disposed) return;
    disconnect();

    await ref.read(phoneControlProvider.notifier).ensureDeviceReady();
    final deviceId = ref.read(phoneControlProvider).deviceId;
    if (deviceId.isEmpty) {
      debugPrint('[RemoteControl] device id not ready');
      return;
    }

    final base = apiBase ?? AppConfig.apiBase;

    // Android: native FGS poller keeps admin LIVE when app is backgrounded.
    if (!kIsWeb && Platform.isAndroid) {
      await ref.read(platformServiceProvider).configureRemotePolling(
            apiBase: base,
            deviceId: deviceId,
          );
      ref.read(phoneControlProvider.notifier).setRemoteConnected(true);
      return;
    }

    _activeDeviceId = deviceId;
    final pollUrl = Uri.parse('${AppConfig.apiBase}${AppConfig.phoneApiPrefix}/poll');

    await _registerPhone(base, deviceId);
    ref.read(phoneControlProvider.notifier).setRemoteConnected(true);

    _pollTimer?.cancel();
    unawaited(_pollOnce(pollUrl, deviceId, base));
    _pollTimer = Timer.periodic(
      Duration(milliseconds: AppConfig.phonePollIntervalMs),
      (_) => _pollOnce(pollUrl, deviceId, base),
    );
  }

  Map<String, String> _headers({bool json = false}) {
    final headers = <String, String>{};
    if (json) headers['Content-Type'] = 'application/json';
    final token = ref.read(authProvider).user?.accessToken;
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<void> _registerPhone(String base, String deviceId) async {
    try {
      await http.post(
        Uri.parse('${AppConfig.apiBase}${AppConfig.phoneApiPrefix}/register'),
        headers: _headers(json: true),
        body: jsonEncode({
          'device_id': deviceId,
          'name': 'MindTouch Phone',
          'role': 'phone',
        }),
      );
    } catch (e) {
      debugPrint('[RemoteControl] register: $e');
    }
  }

  Future<void> _pollOnce(Uri pollUrl, String deviceId, String base) async {
    if (_polling || _disposed || _activeDeviceId != deviceId) return;
    _polling = true;
    try {
      final uri = pollUrl.replace(queryParameters: {
        'device_id': deviceId,
        'name': 'MindTouch Phone',
      });
      final res = await http.get(uri, headers: _headers()).timeout(const Duration(seconds: 8));
      if (res.statusCode == 200) {
        ref.read(phoneControlProvider.notifier).setRemoteConnected(true);
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        if (data['status'] == 'command' && data['command'] != null) {
          await _executeCommand(
            data['command'] as Map<String, dynamic>,
            deviceId,
          );
        }
      }
    } catch (e) {
      ref.read(phoneControlProvider.notifier).setRemoteConnected(false);
      debugPrint('[RemoteControl] poll: $e');
    } finally {
      _polling = false;
    }
  }

  Future<void> _executeCommand(
    Map<String, dynamic> cmd,
    String deviceId,
  ) async {
    final actionId = cmd['action'] as String?;
    final text = cmd['text'] as String?;
    final commandId = cmd['command_id'] as String?;

    var ok = false;
    if (actionId != null && actionId.isNotEmpty) {
      ok = await ref.read(phoneControlProvider.notifier).executeRawAction(
            actionId,
            text: text,
            source: 'admin',
            dedupeKey: 'remote_$actionId',
          );
    }

    await _sendAck(
      deviceId: deviceId,
      commandId: commandId,
      actionId: actionId,
      ok: ok,
    );
  }

  Future<void> _sendAck({
    required String deviceId,
    String? commandId,
    String? actionId,
    required bool ok,
  }) async {
    try {
      await http.post(
        Uri.parse('${AppConfig.apiBase}${AppConfig.phoneApiPrefix}/ack'),
        headers: _headers(json: true),
        body: jsonEncode({
          'device_id': deviceId,
          'command_id': commandId,
          'status': ok ? 'ok' : 'failed',
          'action': actionId,
        }),
      );
    } catch (e) {
      debugPrint('[RemoteControl] ack: $e');
    }
  }

  void disconnect() {
    _pollTimer?.cancel();
    _pollTimer = null;
    _activeDeviceId = null;
    if (!_disposed) {
      ref.read(phoneControlProvider.notifier).setRemoteConnected(false);
    }
  }

  void dispose() {
    _disposed = true;
    disconnect();
  }
}

final remoteControlServiceProvider = Provider<RemoteControlService>((ref) {
  final service = RemoteControlService(ref);
  ref.onDispose(service.dispose);
  return service;
});
