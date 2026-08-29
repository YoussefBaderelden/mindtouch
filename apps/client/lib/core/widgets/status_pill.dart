import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../domain/models/connection_status.dart';
import '../theme/app_colors.dart';

class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.status});

  final ConnectionStatus status;

  Color get _accentColor => switch (status.phase) {
        ConnectionPhase.listening => AppColors.success,
        ConnectionPhase.connected => AppColors.primary,
        ConnectionPhase.calibrating => AppColors.confirm,
        ConnectionPhase.error => AppColors.danger,
        _ => AppColors.textMuted,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: _accentColor.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (status.isLive)
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _accentColor,
                boxShadow: [
                  BoxShadow(
                    color: _accentColor.withValues(alpha: 0.6),
                    blurRadius: 8,
                  ),
                ],
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(
                  begin: const Offset(0.85, 0.85),
                  end: const Offset(1.15, 1.15),
                  duration: 900.ms,
                )
          else
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _accentColor,
              ),
            ),
          const SizedBox(width: 8),
          Text(
            status.phaseLabel,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
          ),
          if (status.latencyMs != null) ...[
            const SizedBox(width: 8),
            Text(
              '${status.latencyMs}ms',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textMuted,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
