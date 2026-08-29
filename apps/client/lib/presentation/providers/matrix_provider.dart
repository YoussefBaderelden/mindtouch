import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/direction.dart';
import '../../domain/models/matrix_cell.dart';
import '../../domain/models/surface.dart';
import '../../domain/navigation/matrix_layouts.dart';
import 'phone_control_provider.dart';

class MatrixState {
  const MatrixState({
    required this.screen,
    required this.selectedIndex,
    required this.activeSurface,
    this.lastConfirmedCell,
    this.showFeedback = false,
    this.lastExecutionSuccess,
  });

  final MatrixScreen screen;
  final int selectedIndex;
  final ControlSurface activeSurface;
  final MatrixCell? lastConfirmedCell;
  final bool showFeedback;
  final bool? lastExecutionSuccess;

  MatrixCell get selectedCell => screen.cells[selectedIndex];

  MatrixState copyWith({
    MatrixScreen? screen,
    int? selectedIndex,
    ControlSurface? activeSurface,
    MatrixCell? lastConfirmedCell,
    bool? showFeedback,
    bool? lastExecutionSuccess,
    bool clearFeedback = false,
  }) {
    return MatrixState(
      screen: screen ?? this.screen,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      activeSurface: activeSurface ?? this.activeSurface,
      lastConfirmedCell: clearFeedback
          ? null
          : (lastConfirmedCell ?? this.lastConfirmedCell),
      showFeedback: clearFeedback ? false : (showFeedback ?? this.showFeedback),
      lastExecutionSuccess:
          clearFeedback ? null : (lastExecutionSuccess ?? this.lastExecutionSuccess),
    );
  }
}

final matrixProvider = NotifierProvider<MatrixNotifier, MatrixState>(
  MatrixNotifier.new,
);

class MatrixNotifier extends Notifier<MatrixState> {
  @override
  MatrixState build() {
    return MatrixState(
      screen: MatrixLayouts.home(surface: ControlSurface.phone),
      selectedIndex: 0,
      activeSurface: ControlSurface.phone,
    );
  }

  void setSurface(ControlSurface surface) {
    final screen = switch (surface) {
      ControlSurface.smartHome => MatrixLayouts.smartHomeRooms(),
      ControlSurface.medical => MatrixLayouts.medical(),
      _ => MatrixLayouts.home(surface: surface),
    };
    state = state.copyWith(
      activeSurface: surface,
      screen: screen,
      selectedIndex: 0,
      clearFeedback: true,
    );
  }

  Future<void> handleDirection(Direction direction) async {
    final phone = ref.read(phoneControlProvider.notifier);
    final phoneState = ref.read(phoneControlProvider);
    final surface = state.activeSurface;
    final direct = surface == ControlSurface.phone && phoneState.directMode;

    final cells = state.screen.cells;
    var index = state.selectedIndex;
    bool? execSuccess;

    switch (direction) {
      case Direction.up:
        index = (index - 1).clamp(0, cells.length - 1);
        if (direct) execSuccess = await phone.executeFromDirection(direction);
      case Direction.down:
        index = (index + 1).clamp(0, cells.length - 1);
        if (direct) execSuccess = await phone.executeFromDirection(direction);
      case Direction.left:
        index = index > 0 ? index - 1 : cells.length - 1;
        if (direct) execSuccess = await phone.executeFromDirection(direction);
      case Direction.right:
        index = index < cells.length - 1 ? index + 1 : 0;
        if (direct) execSuccess = await phone.executeFromDirection(direction);
      case Direction.confirm:
        if (direct) {
          execSuccess = await phone.executeFromDirection(direction);
          state = state.copyWith(
            selectedIndex: index,
            showFeedback: true,
            lastExecutionSuccess: execSuccess,
            lastConfirmedCell: cells[index],
          );
        } else {
          await _confirmCell(cells[index]);
        }
        return;
      case Direction.cancel:
        if (direct) {
          execSuccess = await phone.executeFromDirection(direction);
          state = state.copyWith(
            showFeedback: true,
            lastExecutionSuccess: execSuccess,
            lastConfirmedCell: cells.firstWhere(
              (c) => c.isCancel,
              orElse: () => cells[index],
            ),
          );
        } else {
          final cancelIndex = cells.indexWhere((c) => c.isCancel);
          if (cancelIndex >= 0) await _confirmCell(cells[cancelIndex]);
        }
        return;
    }

    state = state.copyWith(selectedIndex: index);
  }

  Future<void> _confirmCell(MatrixCell cell) async {
    var success = true;
    if (state.activeSurface == ControlSurface.phone && !cell.isCancel) {
      success = await ref.read(phoneControlProvider.notifier).executeFromCell(
            cell.id,
          );
    } else if (cell.isCancel && state.activeSurface == ControlSurface.phone) {
      success = await ref.read(phoneControlProvider.notifier).executeFromCell(
            'nav_back',
          );
    }

    state = state.copyWith(
      lastConfirmedCell: cell,
      showFeedback: true,
      lastExecutionSuccess: success,
    );
  }

  void clearFeedback() {
    state = state.copyWith(clearFeedback: true);
  }

  void selectIndex(int index) {
    state = state.copyWith(
      selectedIndex: index.clamp(0, state.screen.cells.length - 1),
    );
  }
}
