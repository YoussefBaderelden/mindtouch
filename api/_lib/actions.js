export const PHONE_ACTIONS = [
  { id: 'tap_center', label: 'Tap Center', category: 'Tap', description: 'Tap screen center' },
  { id: 'tap_top', label: 'Tap Top', category: 'Tap', description: 'Tap upper area' },
  { id: 'tap_bottom', label: 'Tap Bottom', category: 'Tap', description: 'Tap lower area' },
  { id: 'tap_left', label: 'Tap Left', category: 'Tap', description: 'Tap left side' },
  { id: 'tap_right', label: 'Tap Right', category: 'Tap', description: 'Tap right side' },
  { id: 'double_tap', label: 'Double Tap', category: 'Tap', description: 'Double tap center' },
  { id: 'long_press', label: 'Long Press', category: 'Tap', description: 'Long press center' },
  { id: 'scroll_up', label: 'Scroll Up', category: 'Scroll & Swipe', description: 'Scroll up' },
  { id: 'scroll_down', label: 'Scroll Down', category: 'Scroll & Swipe', description: 'Scroll down' },
  { id: 'scroll_left', label: 'Scroll Left', category: 'Scroll & Swipe', description: 'Scroll left' },
  { id: 'scroll_right', label: 'Scroll Right', category: 'Scroll & Swipe', description: 'Scroll right' },
  { id: 'swipe_up', label: 'Swipe Up', category: 'Scroll & Swipe', description: 'Swipe up' },
  { id: 'swipe_down', label: 'Swipe Down', category: 'Scroll & Swipe', description: 'Swipe down' },
  { id: 'swipe_left', label: 'Swipe Left', category: 'Scroll & Swipe', description: 'Swipe left' },
  { id: 'swipe_right', label: 'Swipe Right', category: 'Scroll & Swipe', description: 'Swipe right' },
  { id: 'back', label: 'Back', category: 'Navigation', description: 'Android back' },
  { id: 'home', label: 'Home', category: 'Navigation', description: 'Home screen' },
  { id: 'recents', label: 'Recents', category: 'Navigation', description: 'App switcher' },
  { id: 'notifications', label: 'Notifications', category: 'Navigation', description: 'Notification shade' },
  { id: 'quick_settings', label: 'Quick Settings', category: 'Navigation', description: 'Quick settings' },
  { id: 'type_text', label: 'Type Text', category: 'Chat & Text', description: 'Type into focused field' },
  { id: 'delete', label: 'Delete', category: 'Chat & Text', description: 'Delete character' },
  { id: 'enter', label: 'Enter / Send', category: 'Chat & Text', description: 'Send message' },
  { id: 'paste', label: 'Paste', category: 'Chat & Text', description: 'Paste clipboard' },
  { id: 'select_all', label: 'Select All', category: 'Chat & Text', description: 'Select all text' },
  { id: 'focus_search', label: 'Focus Chat', category: 'Chat & Text', description: 'Focus search/chat input' },
];

export const DIRECTION_MAP = {
  up: 'scroll_up',
  down: 'scroll_down',
  left: 'swipe_left',
  right: 'swipe_right',
  confirm: 'tap_center',
  cancel: 'back',
};

export const DIRECTIONS = Object.keys(DIRECTION_MAP);
