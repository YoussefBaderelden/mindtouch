import '../domain/models/phone_action.dart';

abstract class PhoneControlService {
  Future<bool> isAccessibilityEnabled();
  Future<void> openAccessibilitySettings();
  Future<bool> execute(PhoneAction action, {String? text});
}
