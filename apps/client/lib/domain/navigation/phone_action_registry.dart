import '../models/phone_action.dart';

/// Maps matrix cell IDs to concrete phone actions.
abstract final class PhoneActionRegistry {
  static const chatSampleText = 'Hello! This is a MindTouch test message.';

  static PhoneAction? actionForCell(String cellId) {
    return _cellActions[cellId];
  }

  static const Map<String, PhoneAction> _cellActions = {
    // Scroll & swipe
    'scroll_up': PhoneAction.scrollUp,
    'scroll_down': PhoneAction.scrollDown,
    'scroll_left': PhoneAction.scrollLeft,
    'scroll_right': PhoneAction.scrollRight,
    'swipe_up': PhoneAction.swipeUp,
    'swipe_down': PhoneAction.swipeDown,
    'swipe_left': PhoneAction.swipeLeft,
    'swipe_right': PhoneAction.swipeRight,
    // Tap
    'tap_center': PhoneAction.tapCenter,
    'tap_top': PhoneAction.tapTop,
    'tap_bottom': PhoneAction.tapBottom,
    'double_tap': PhoneAction.doubleTap,
    'long_press': PhoneAction.longPress,
    // Navigation
    'nav_back': PhoneAction.back,
    'nav_home': PhoneAction.home,
    'nav_recents': PhoneAction.recents,
    'nav_notifications': PhoneAction.notifications,
    // Chat
    'chat_type': PhoneAction.typeText,
    'chat_delete': PhoneAction.deleteChar,
    'chat_enter': PhoneAction.enter,
    'chat_paste': PhoneAction.paste,
    'chat_focus': PhoneAction.focusSearch,
    // Matrix nav helpers also execute when confirmed on phone surface
    'nav_up': PhoneAction.scrollUp,
    'nav_down': PhoneAction.scrollDown,
    'nav_left': PhoneAction.swipeLeft,
    'nav_right': PhoneAction.swipeRight,
    'confirm': PhoneAction.tapCenter,
    'cancel': PhoneAction.back,
  };

  static String? textForCell(String cellId) {
    if (cellId == 'chat_type') return chatSampleText;
    return null;
  }
}
