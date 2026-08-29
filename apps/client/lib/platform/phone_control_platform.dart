import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../domain/models/phone_action.dart';
import 'phone_control_service.dart';

class AndroidPhoneControlService implements PhoneControlService {
  AndroidPhoneControlService();

  static const _channel = MethodChannel('com.mindtouch/phone_control');

  @override
  Future<bool> isAccessibilityEnabled() async {
    if (!Platform.isAndroid) return false;
    try {
      return await _channel.invokeMethod<bool>('isAccessibilityEnabled') ?? false;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> openAccessibilitySettings() async {
    if (!Platform.isAndroid) return;
    await _channel.invokeMethod<void>('openAccessibilitySettings');
  }

  @override
  Future<bool> execute(PhoneAction action, {String? text}) async {
    if (!Platform.isAndroid) {
      debugPrint('[MindTouch] Phone action (stub): ${action.id}');
      return true;
    }
    try {
      return await _channel.invokeMethod<bool>('executeAction', {
            'action': action.id,
            'text': text,
          }) ??
          false;
    } on PlatformException catch (e) {
      debugPrint('[MindTouch] execute failed: ${e.message}');
      return false;
    }
  }
}

class StubPhoneControlService implements PhoneControlService {
  @override
  Future<bool> isAccessibilityEnabled() async => false;

  @override
  Future<void> openAccessibilitySettings() async {}

  @override
  Future<bool> execute(PhoneAction action, {String? text}) async {
    debugPrint('[MindTouch stub] ${action.id}${text != null ? ': $text' : ''}');
    return true;
  }
}

PhoneControlService createPhoneControlService() {
  if (!kIsWeb && Platform.isAndroid) {
    return AndroidPhoneControlService();
  }
  return StubPhoneControlService();
}
