import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/models/direction.dart';
import '../../domain/models/matrix_cell.dart';
import '../providers/connection_provider.dart';
import '../providers/matrix_provider.dart';
import '../providers/phone_control_provider.dart';
import '../widgets/confirmation_overlay.dart';
import '../widgets/direction_control_strip.dart';
import '../widgets/matrix_grid.dart';
import '../widgets/mind_touch_scaffold.dart';
import '../widgets/surface_selector.dart';

class ControlScreen extends ConsumerStatefulWidget {
  const ControlScreen({super.key});

  @override
  ConsumerState<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends ConsumerState<ControlScreen> {
  Direction? _lastDirection;
  Timer? _feedbackTimer;
  bool _handlingDirection = false;

  @override
  void dispose() {
    _feedbackTimer?.cancel();
    super.dispose();
  }

  Future<void> _handleDirection(Direction direction) async {
    if (_handlingDirection) return;
    _handlingDirection = true;

    setState(() => _lastDirection = direction);
    ref.read(lastDirectionProvider.notifier).state = direction;

    try {
      await ref.read(matrixProvider.notifier).handleDirection(direction);
      _scheduleFeedbackDismiss();
    } finally {
      _handlingDirection = false;
    }
  }

  void _scheduleFeedbackDismiss() {
    _feedbackTimer?.cancel();
    final matrix = ref.read(matrixProvider);
    if (!matrix.showFeedback) return;

    _feedbackTimer = Timer(
      Duration(milliseconds: AppConfig.feedbackAutoDismissMs),
      () {
        if (mounted) {
          ref.read(matrixProvider.notifier).clearFeedback();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final matrix = ref.watch(matrixProvider);
    final connection = ref.watch(connectionProvider);
    final phoneControl = ref.watch(phoneControlProvider);

    ref.listen(matrixProvider, (prev, next) {
      if (next.showFeedback && prev?.showFeedback != true) {
        _scheduleFeedbackDismiss();
      }
    });

    return Stack(
      children: [
        MindTouchScaffold(
          title: matrix.screen.title,
          subtitle: matrix.screen.subtitle,
          breadcrumb: matrix.screen.breadcrumb,
          connectionStatus: connection,
          lastDirection: _lastDirection,
          actions: [
            _DirectModeToggle(
              enabled: phoneControl.directMode,
              accessibilityEnabled: phoneControl.accessibilityEnabled,
              remoteConnected: phoneControl.remoteConnected,
              isExecuting: phoneControl.isExecuting,
              onToggle: (v) =>
                  ref.read(phoneControlProvider.notifier).setDirectMode(v),
            ),
          ],
          bottomBar: Column(
            children: [
              if (!phoneControl.accessibilityEnabled)
                _AccessibilityBanner(
                  onEnable: () => ref
                      .read(phoneControlProvider.notifier)
                      .openAccessibilitySettings(),
                ),
              SurfaceSelector(
                active: matrix.activeSurface,
                onChanged: (surface) {
                  ref.read(matrixProvider.notifier).setSurface(surface);
                },
              ),
              const SizedBox(height: 12),
              DirectionControlStrip(onDirection: _handleDirection),
            ],
          ),
          body: MatrixGrid(
            cells: matrix.screen.cells,
            selectedIndex: matrix.selectedIndex,
            onCellTap: (index) {
              ref.read(matrixProvider.notifier).selectIndex(index);
            },
          ),
        ),
        if (matrix.showFeedback && matrix.lastConfirmedCell != null)
          ConfirmationOverlay(
            title: _feedbackTitle(matrix.lastConfirmedCell!, matrix),
            message: _feedbackMessage(matrix.lastConfirmedCell!, matrix),
            icon: matrix.lastConfirmedCell!.icon,
            accentColor: _feedbackColor(matrix.lastConfirmedCell!, matrix),
            onDismiss: () {
              _feedbackTimer?.cancel();
              ref.read(matrixProvider.notifier).clearFeedback();
            },
          ),
      ],
    );
  }

  String _feedbackTitle(MatrixCell cell, MatrixState matrix) {
    if (matrix.lastExecutionSuccess == false) return 'Action Failed';
    if (cell.isSos) return 'SOS Armed';
    if (cell.isConfirm) return 'Action Confirmed';
    if (cell.isCancel) return 'Back';
    return '${cell.label} Executed';
  }

  String _feedbackMessage(MatrixCell cell, MatrixState matrix) {
    if (matrix.lastExecutionSuccess == false) {
      return 'Enable Accessibility in Setup, then retry.';
    }
    if (cell.isSos) {
      return 'Caregivers will be alerted on second confirm.';
    }
    return '${cell.subtitle} — sent to phone OS.';
  }

  Color _feedbackColor(MatrixCell cell, MatrixState matrix) {
    if (matrix.lastExecutionSuccess == false) return AppColors.danger;
    if (cell.isSos) return AppColors.danger;
    if (cell.isConfirm) return AppColors.confirm;
    if (cell.isCancel) return AppColors.textMuted;
    return AppColors.primary;
  }
}

class _DirectModeToggle extends StatelessWidget {
  const _DirectModeToggle({
    required this.enabled,
    required this.accessibilityEnabled,
    required this.remoteConnected,
    required this.isExecuting,
    required this.onToggle,
  });

  final bool enabled;
  final bool accessibilityEnabled;
  final bool remoteConnected;
  final bool isExecuting;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Direct',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: enabled ? AppColors.primary : AppColors.textMuted,
                  ),
            ),
            Switch(
              value: enabled,
              onChanged: onToggle,
              activeThumbColor: AppColors.primary,
            ),
          ],
        ),
        if (isExecuting)
          Text(
            'Executing…',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.confirm,
                ),
          )
        else if (remoteConnected)
          Text(
            'Admin linked',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.success,
                ),
          )
        else if (!accessibilityEnabled)
          Text(
            'A11y off',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.warning,
                ),
          ),
      ],
    );
  }
}

class _AccessibilityBanner extends StatelessWidget {
  const _AccessibilityBanner({required this.onEnable});

  final VoidCallback onEnable;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          const Icon(Icons.accessibility_new_rounded, color: AppColors.warning),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Enable Accessibility to control your phone',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textPrimary,
                  ),
            ),
          ),
          TextButton(onPressed: onEnable, child: const Text('Enable')),
        ],
      ),
    );
  }
}
