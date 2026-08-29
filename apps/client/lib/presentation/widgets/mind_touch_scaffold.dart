import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart' hide Direction;

import '../../core/theme/app_colors.dart';
import '../../core/widgets/neural_background.dart';
import '../../core/widgets/signal_meter.dart';
import '../../core/widgets/status_pill.dart';
import '../../domain/models/connection_status.dart';
import '../../domain/models/direction.dart';

class MindTouchScaffold extends StatelessWidget {
  const MindTouchScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.body,
    this.breadcrumb,
    this.connectionStatus,
    this.lastDirection,
    this.bottomBar,
    this.actions,
  });

  final String title;
  final String subtitle;
  final Widget body;
  final List<String>? breadcrumb;
  final ConnectionStatus? connectionStatus;
  final Direction? lastDirection;
  final Widget? bottomBar;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: NeuralBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: textTheme.displaySmall,
                          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: textTheme.bodyMedium,
                          ).animate(delay: 100.ms).fadeIn(),
                          if (breadcrumb != null && breadcrumb!.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 6,
                              children: [
                                for (var i = 0; i < breadcrumb!.length; i++) ...[
                                  _BreadcrumbChip(
                                    label: breadcrumb![i],
                                    active: i == breadcrumb!.length - 1,
                                  ),
                                  if (i < breadcrumb!.length - 1)
                                    Icon(
                                      Icons.chevron_right_rounded,
                                      size: 16,
                                      color: AppColors.textMuted.withValues(alpha: 0.7),
                                    ),
                                ],
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (actions != null) ...actions!,
                  ],
                ),
                const SizedBox(height: 12),
                if (connectionStatus != null)
                  Row(
                    children: [
                      StatusPill(status: connectionStatus!),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SignalMeter(quality: connectionStatus!.signalQuality),
                      ),
                    ],
                  ).animate(delay: 150.ms).fadeIn().slideY(begin: 0.08),
                if (lastDirection != null) ...[
                  const SizedBox(height: 10),
                  DirectionFeedback(direction: lastDirection!),
                ],
                const SizedBox(height: 16),
                Expanded(child: body),
                if (bottomBar != null) ...[
                  const SizedBox(height: 12),
                  bottomBar!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BreadcrumbChip extends StatelessWidget {
  const _BreadcrumbChip({required this.label, required this.active});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: active
            ? AppColors.primary.withValues(alpha: 0.12)
            : AppColors.surfaceElevated.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: active
              ? AppColors.primary.withValues(alpha: 0.35)
              : AppColors.border.withValues(alpha: 0.5),
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: active ? AppColors.primary : AppColors.textMuted,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class DirectionFeedback extends StatelessWidget {
  const DirectionFeedback({super.key, required this.direction});

  final Direction direction;

  IconData get _icon => switch (direction) {
        Direction.up => Icons.arrow_upward_rounded,
        Direction.down => Icons.arrow_downward_rounded,
        Direction.left => Icons.arrow_back_rounded,
        Direction.right => Icons.arrow_forward_rounded,
        Direction.confirm => Icons.check_rounded,
        Direction.cancel => Icons.close_rounded,
      };

  Color get _color => switch (direction) {
        Direction.confirm => AppColors.confirm,
        Direction.cancel => AppColors.textMuted,
        _ => AppColors.primary,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _color.withValues(alpha: 0.15),
            _color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, color: _color, size: 18),
          const SizedBox(width: 8),
          Text(
            direction.hint,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textPrimary,
                ),
          ),
        ],
      ),
    ).animate(key: ValueKey(direction)).fadeIn(duration: 200.ms).scale(
          begin: const Offset(0.95, 0.95),
          curve: Curves.easeOutBack,
        );
  }
}
