import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class DeviceProfile {
  const DeviceProfile({
    required this.platform,
    required this.model,
    required this.osVersion,
    required this.deviceId,
    required this.manufacturer,
  });

  final String platform;
  final String model;
  final String osVersion;
  final String deviceId;
  final String manufacturer;

  Map<String, dynamic> toJson() => {
        'platform': platform,
        'model': model,
        'os_version': osVersion,
        'device_id': deviceId,
        'manufacturer': manufacturer,
      };
}

class PlatformService {
  PlatformService();

  static const _platform = MethodChannel('com.mindtouch/platform');

  Future<DeviceProfile> getDeviceProfile() async {
    final plugin = DeviceInfoPlugin();
    if (kIsWeb) {
      final web = await plugin.webBrowserInfo;
      return DeviceProfile(
        platform: 'web',
        model: web.browserName.name,
        osVersion: web.platform ?? 'unknown',
        deviceId: 'web-${web.userAgent?.hashCode ?? 0}',
        manufacturer: 'browser',
      );
    }
    if (Platform.isAndroid) {
      final info = await plugin.androidInfo;
      return DeviceProfile(
        platform: 'android',
        model: info.model,
        osVersion: 'Android ${info.version.release} (API ${info.version.sdkInt})',
        deviceId: info.id,
        manufacturer: info.manufacturer,
      );
    }
    if (Platform.isWindows) {
      final info = await plugin.windowsInfo;
      return DeviceProfile(
        platform: 'windows',
        model: info.computerName,
        osVersion: '${info.displayVersion} build ${info.buildNumber}',
        deviceId: info.deviceId,
        manufacturer: 'microsoft',
      );
    }
    return const DeviceProfile(
      platform: 'unknown',
      model: 'unknown',
      osVersion: 'unknown',
      deviceId: 'unknown',
      manufacturer: 'unknown',
    );
  }

  Future<Map<String, dynamic>> getPermissionStatus() async {
    if (!Platform.isAndroid) {
      return {'accessibility': false, 'overlay': false, 'battery_exemption': true};
    }
    try {
      final result = await _platform.invokeMethod<Map>('getPermissionStatus');
      return Map<String, dynamic>.from(result ?? {});
    } catch (_) {
      return {};
    }
  }

  Future<void> startBackgroundService({
    String apiBase = '',
    String deviceId = '',
  }) async {
    if (!Platform.isAndroid) return;
    await _platform.invokeMethod<void>('startBackgroundService', {
      'api_base': apiBase,
      'device_id': deviceId,
    });
  }

  Future<void> configureRemotePolling({
    required String apiBase,
    required String deviceId,
  }) async {
    if (!Platform.isAndroid) return;
    await _platform.invokeMethod<void>('configureRemotePolling', {
      'api_base': apiBase,
      'device_id': deviceId,
    });
  }

  Future<void> stopBackgroundService() async {
    if (!Platform.isAndroid) return;
    await _platform.invokeMethod<void>('stopBackgroundService');
  }

  Future<bool> isBackgroundServiceRunning() async {
    if (!Platform.isAndroid) return false;
    return await _platform.invokeMethod<bool>('isBackgroundServiceRunning') ?? false;
  }

  Future<void> updateBubbleMessage(String message) async {
    if (!Platform.isAndroid) return;
    await _platform.invokeMethod<void>('updateBubbleMessage', {'message': message});
  }

  Future<bool> canDrawOverlays() async {
    if (!Platform.isAndroid) return false;
    return await _platform.invokeMethod<bool>('canDrawOverlays') ?? false;
  }

  Future<void> requestOverlayPermission() async {
    if (!Platform.isAndroid) return;
    await _platform.invokeMethod<void>('requestOverlayPermission');
  }

  Future<bool> isBatteryOptimizationIgnored() async {
    if (!Platform.isAndroid) return true;
    return await _platform.invokeMethod<bool>('isBatteryOptimizationIgnored') ?? true;
  }

  Future<void> requestBatteryOptimization() async {
    if (!Platform.isAndroid) return;
    await _platform.invokeMethod<void>('requestBatteryOptimization');
  }

  Future<void> showFloatingBubble(String message) async {
    if (!Platform.isAndroid) return;
    await _platform.invokeMethod<void>('showFloatingBubble', {'message': message});
  }
}
