import 'direction.dart';

/// Every phone action MindTouch can execute via Accessibility Service.
enum PhoneAction {
  tapCenter('tap_center', 'Tap Center', 'Tap screen center'),
  tapTop('tap_top', 'Tap Top', 'Tap upper area'),
  tapBottom('tap_bottom', 'Tap Bottom', 'Tap lower area'),
  tapLeft('tap_left', 'Tap Left', 'Tap left side'),
  tapRight('tap_right', 'Tap Right', 'Tap right side'),
  doubleTap('double_tap', 'Double Tap', 'Double tap center'),
  longPress('long_press', 'Long Press', 'Long press center'),

  scrollUp('scroll_up', 'Scroll Up', 'Scroll content up'),
  scrollDown('scroll_down', 'Scroll Down', 'Scroll content down'),
  scrollLeft('scroll_left', 'Scroll Left', 'Scroll content left'),
  scrollRight('scroll_right', 'Scroll Right', 'Scroll content right'),

  swipeUp('swipe_up', 'Swipe Up', 'Fast swipe up'),
  swipeDown('swipe_down', 'Swipe Down', 'Fast swipe down'),
  swipeLeft('swipe_left', 'Swipe Left', 'Fast swipe left'),
  swipeRight('swipe_right', 'Swipe Right', 'Fast swipe right'),

  back('back', 'Back', 'Android back button'),
  home('home', 'Home', 'Go to home screen'),
  exitApp('exit_app', 'Exit App', 'Leave current app and return home'),
  recents('recents', 'Recents', 'Open app switcher'),
  notifications('notifications', 'Notifications', 'Open notification shade'),
  quickSettings('quick_settings', 'Quick Settings', 'Open quick settings'),

  typeText('type_text', 'Type Text', 'Type into focused field'),
  deleteChar('delete', 'Delete', 'Delete character'),
  enter('enter', 'Enter / Send', 'Press enter or send'),
  paste('paste', 'Paste', 'Paste from clipboard'),
  selectAll('select_all', 'Select All', 'Select all text'),
  focusSearch('focus_search', 'Focus Search', 'Focus search or chat input'),
  showKeyboard('show_keyboard', 'Show Keyboard', 'Focus field and open keyboard'),
  typeChar('type_char', 'Type Character', 'Type one character'),
  typeMessage('type_message', 'Type Message Live', 'Type message character by character'),
  clearText('clear_text', 'Clear Text', 'Clear the focused text field');

  const PhoneAction(this.id, this.label, this.description);

  final String id;
  final String label;
  final String description;

  static PhoneAction? fromId(String id) {
    for (final action in PhoneAction.values) {
      if (action.id == id) return action;
    }
    return null;
  }

  /// Default AI direction → phone action mapping for direct control mode.
  static PhoneAction fromDirection(Direction direction) {
    return switch (direction) {
      Direction.up => PhoneAction.scrollUp,
      Direction.down => PhoneAction.scrollDown,
      Direction.left => PhoneAction.swipeLeft,
      Direction.right => PhoneAction.swipeRight,
      Direction.confirm => PhoneAction.tapCenter,
      Direction.cancel => PhoneAction.back,
    };
  }

  String get category => switch (this) {
        PhoneAction.tapCenter ||
        PhoneAction.tapTop ||
        PhoneAction.tapBottom ||
        PhoneAction.tapLeft ||
        PhoneAction.tapRight ||
        PhoneAction.doubleTap ||
        PhoneAction.longPress =>
          'Tap',
        PhoneAction.scrollUp ||
        PhoneAction.scrollDown ||
        PhoneAction.scrollLeft ||
        PhoneAction.scrollRight ||
        PhoneAction.swipeUp ||
        PhoneAction.swipeDown ||
        PhoneAction.swipeLeft ||
        PhoneAction.swipeRight =>
          'Scroll & Swipe',
        PhoneAction.back ||
        PhoneAction.home ||
        PhoneAction.exitApp ||
        PhoneAction.recents ||
        PhoneAction.notifications ||
        PhoneAction.quickSettings =>
          'Navigation',
        _ => 'Chat & Text',
      };

  bool get needsText =>
      this == PhoneAction.typeText ||
      this == PhoneAction.typeChar ||
      this == PhoneAction.typeMessage;
}
