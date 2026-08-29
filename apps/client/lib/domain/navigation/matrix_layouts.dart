import 'package:flutter/material.dart';

import '../models/matrix_cell.dart';
import '../models/surface.dart';

class MatrixScreen {
  const MatrixScreen({
    required this.title,
    required this.subtitle,
    required this.cells,
    this.breadcrumb,
  });

  final String title;
  final String subtitle;
  final List<MatrixCell> cells;
  final List<String>? breadcrumb;
}

/// Pre-built matrix layouts for each app surface.
abstract final class MatrixLayouts {
  static MatrixScreen home({required ControlSurface surface}) {
    if (surface == ControlSurface.phone) {
      return phoneControl();
    }
    return MatrixScreen(
      title: 'MindTouch',
      subtitle: 'Imagine a direction to navigate',
      breadcrumb: [surface.shortLabel],
      cells: const [
        MatrixCell(
          id: 'nav_up',
          label: 'Up',
          subtitle: 'Previous option',
          icon: Icons.keyboard_arrow_up_rounded,
          directionHint: 'Imagine up',
        ),
        MatrixCell(
          id: 'nav_down',
          label: 'Down',
          subtitle: 'Next option',
          icon: Icons.keyboard_arrow_down_rounded,
          directionHint: 'Imagine down',
        ),
        MatrixCell(
          id: 'nav_left',
          label: 'Left',
          subtitle: 'Move selection',
          icon: Icons.keyboard_arrow_left_rounded,
          directionHint: 'Imagine left',
        ),
        MatrixCell(
          id: 'nav_right',
          label: 'Right',
          subtitle: 'Move selection',
          icon: Icons.keyboard_arrow_right_rounded,
          directionHint: 'Imagine right',
        ),
        MatrixCell(
          id: 'confirm',
          label: 'Confirm',
          subtitle: 'Execute action',
          icon: Icons.check_circle_outline_rounded,
          kind: MatrixCellKind.confirm,
          directionHint: 'Imagine confirm',
        ),
        MatrixCell(
          id: 'cancel',
          label: 'Back',
          subtitle: 'Go back safely',
          icon: Icons.close_rounded,
          kind: MatrixCellKind.cancel,
          directionHint: 'Imagine cancel',
        ),
      ],
    );
  }

  /// Full phone control matrix — every test case mapped to a cell.
  static MatrixScreen phoneControl() {
    return const MatrixScreen(
      title: 'Phone Control',
      subtitle: 'Imagine a direction, confirm to execute',
      breadcrumb: ['Phone', 'All Actions'],
      cells: [
        MatrixCell(id: 'scroll_up', label: 'Scroll Up', subtitle: 'Scroll content up', icon: Icons.arrow_upward_rounded),
        MatrixCell(id: 'scroll_down', label: 'Scroll Down', subtitle: 'Scroll content down', icon: Icons.arrow_downward_rounded),
        MatrixCell(id: 'scroll_left', label: 'Scroll Left', subtitle: 'Scroll left', icon: Icons.arrow_back_rounded),
        MatrixCell(id: 'scroll_right', label: 'Scroll Right', subtitle: 'Scroll right', icon: Icons.arrow_forward_rounded),
        MatrixCell(id: 'swipe_up', label: 'Swipe Up', subtitle: 'Fast swipe up', icon: Icons.swipe_up_rounded),
        MatrixCell(id: 'swipe_down', label: 'Swipe Down', subtitle: 'Fast swipe down', icon: Icons.swipe_down_rounded),
        MatrixCell(id: 'tap_center', label: 'Tap', subtitle: 'Tap center', icon: Icons.touch_app_rounded),
        MatrixCell(id: 'double_tap', label: 'Double Tap', subtitle: 'Double tap', icon: Icons.ads_click_rounded),
        MatrixCell(id: 'long_press', label: 'Long Press', subtitle: 'Hold press', icon: Icons.back_hand_rounded),
        MatrixCell(id: 'nav_back', label: 'Back', subtitle: 'Android back', icon: Icons.arrow_back_ios_new_rounded),
        MatrixCell(id: 'nav_home', label: 'Home', subtitle: 'Home screen', icon: Icons.home_rounded),
        MatrixCell(id: 'nav_recents', label: 'Recents', subtitle: 'App switcher', icon: Icons.apps_rounded),
        MatrixCell(id: 'chat_focus', label: 'Focus Chat', subtitle: 'Focus input field', icon: Icons.chat_bubble_outline_rounded),
        MatrixCell(id: 'chat_type', label: 'Type Message', subtitle: 'Type test message', icon: Icons.keyboard_rounded),
        MatrixCell(id: 'chat_enter', label: 'Send', subtitle: 'Enter / send', icon: Icons.send_rounded),
        MatrixCell(id: 'chat_delete', label: 'Delete', subtitle: 'Delete char', icon: Icons.backspace_rounded),
        MatrixCell(id: 'chat_paste', label: 'Paste', subtitle: 'Paste clipboard', icon: Icons.content_paste_rounded),
        MatrixCell(
          id: 'cancel',
          label: 'Back',
          subtitle: 'Go back safely',
          icon: Icons.close_rounded,
          kind: MatrixCellKind.cancel,
        ),
      ],
    );
  }

  static MatrixScreen smartHomeRooms() {
    return const MatrixScreen(
      title: 'Smart Home',
      subtitle: 'Select a room',
      breadcrumb: ['Home', 'Rooms'],
      cells: [
        MatrixCell(
          id: 'room_living',
          label: 'Living Room',
          subtitle: '4 devices',
          icon: Icons.weekend_rounded,
        ),
        MatrixCell(
          id: 'room_bedroom',
          label: 'Bedroom',
          subtitle: '3 devices',
          icon: Icons.bed_rounded,
        ),
        MatrixCell(
          id: 'room_kitchen',
          label: 'Kitchen',
          subtitle: '2 devices',
          icon: Icons.kitchen_rounded,
        ),
        MatrixCell(
          id: 'cancel',
          label: 'Back',
          subtitle: 'Return home',
          icon: Icons.close_rounded,
          kind: MatrixCellKind.cancel,
        ),
      ],
    );
  }

  static MatrixScreen medical() {
    return const MatrixScreen(
      title: 'Safety Panel',
      subtitle: 'Emergency & wellness',
      breadcrumb: ['Safety'],
      cells: [
        MatrixCell(
          id: 'sos',
          label: 'SOS',
          subtitle: 'Alert caregivers',
          icon: Icons.emergency_rounded,
          kind: MatrixCellKind.sos,
        ),
        MatrixCell(
          id: 'reminder',
          label: 'Reminders',
          subtitle: 'Medication queue',
          icon: Icons.medication_rounded,
        ),
        MatrixCell(
          id: 'checkin',
          label: 'Check In',
          subtitle: 'Signal you\'re OK',
          icon: Icons.favorite_rounded,
        ),
        MatrixCell(
          id: 'cancel',
          label: 'Back',
          subtitle: 'Return home',
          icon: Icons.close_rounded,
          kind: MatrixCellKind.cancel,
        ),
      ],
    );
  }
}
