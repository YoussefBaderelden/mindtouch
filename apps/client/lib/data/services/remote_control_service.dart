import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../core/config/app_config.dart';
import '../../domain/models/phone_action.dart';
import '../../presentation/providers/auth_provider.dart';
import '../../presentation/providers/phone_control_provider.dart';

/// Cloud + local remote control — HTTP polling for Vercel, WebSocket for Docker.
class RemoteControlService {
  RemoteControlService(this.ref);

  final Ref ref;
  Timer? _pollTimer;
  bool _disposed = false;
  bool _polling = false;

  void connect({String? apiBase}) {
    if (_disposed) return;
    disconnect();

    if (AppConfig.useCloudApi || (apiBase != null && apiBase.startsWith('http'))) {
      _startCloudPolling(apiBase ?? AppConfig.apiBase);
    } else {
      _startLocalPolling(apiBase ?? AppConfig.apiBase);
    }
  }

  void _startCloudPolling(String base) {
    final deviceId = ref.read(phoneControlProvider).deviceId;
    final pollUrl = Uri.parse('${AppConfig.apiBase}${AppConfig.phoneApiPrefix}/poll');

    unawaited(_registerPhone(base, deviceId));

    ref.read(phoneControlProvider.notifier).setRemoteConnected(true);

    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(
      Duration(milliseconds: AppConfig.phonePollIntervalMs),
      (_) => _pollOnce(pollUrl, deviceId, base),
    );
  }

  /// Local Docker FastAPI — poll REST endpoints (same as Vercel, different paths).
  void _startLocalPolling(String base) {
    _startCloudPolling(base);
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
    if (_polling || _disposed) return;
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
            base,
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
    String base,
  ) async {
    final actionId = cmd['action'] as String?;
    final text = cmd['text'] as String?;
    final commandId = cmd['command_id'] as String?;
    final action = PhoneAction.fromId(actionId ?? '');
    if (action == null) return;

    final ok = await ref.read(phoneControlProvider.notifier).executeAction(
          action,
          text: text,
          source: 'admin',
        );

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
    } catch (_) {}
  }

  void disconnect() {
    _pollTimer?.cancel();
    _pollTimer = null;
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
