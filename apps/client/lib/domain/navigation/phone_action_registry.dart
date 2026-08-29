import '../models/phone_action.dart';

/// Maps matrix cell IDs to concrete phone actions.
abstract final class PhoneActionRegistry {
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
    'tap_left': PhoneAction.tapLeft,
    'tap_right': PhoneAction.tapRight,
    'double_tap': PhoneAction.doubleTap,
    'long_press': PhoneAction.longPress,
    // Navigation
    'nav_back': PhoneAction.back,
    'nav_home': PhoneAction.home,
    'exit_app': PhoneAction.exitApp,
    'nav_recents': PhoneAction.recents,
    'nav_notifications': PhoneAction.notifications,
    'nav_quick_settings': PhoneAction.quickSettings,
    // Chat
    'chat_focus': PhoneAction.focusSearch,
    'chat_keyboard': PhoneAction.showKeyboard,
    'chat_delete': PhoneAction.deleteChar,
    'chat_enter': PhoneAction.enter,
    'chat_paste': PhoneAction.paste,
    'chat_select_all': PhoneAction.selectAll,
    'chat_clear': PhoneAction.clearText,
    // Matrix nav helpers
    'nav_up': PhoneAction.scrollUp,
    'nav_down': PhoneAction.scrollDown,
    'nav_left': PhoneAction.swipeLeft,
    'nav_right': PhoneAction.swipeRight,
    'confirm': PhoneAction.tapCenter,
    'cancel': PhoneAction.back,
  };

  static String? textForCell(String cellId) => null;
}
