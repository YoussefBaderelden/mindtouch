import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart' hide Direction;

import '../../core/theme/app_colors.dart';
import '../../domain/models/direction.dart';

/// Debug / demo control strip — simulates BCI directions until hardware is connected.
class DirectionControlStrip extends StatelessWidget {
  const DirectionControlStrip({
    super.key,
    required this.onDirection,
  });

  final ValueChanged<Direction> onDirection;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Simulate Neural Input',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _DirButton(
                icon: Icons.keyboard_arrow_up_rounded,
                onTap: () => onDirection(Direction.up),
              ),
              const SizedBox(width: 8),
              _DirButton(
                icon: Icons.keyboard_arrow_down_rounded,
                onTap: () => onDirection(Direction.down),
              ),
              const SizedBox(width: 8),
              _DirButton(
                icon: Icons.keyboard_arrow_left_rounded,
                onTap: () => onDirection(Direction.left),
              ),
              const SizedBox(width: 8),
              _DirButton(
                icon: Icons.keyboard_arrow_right_rounded,
                onTap: () => onDirection(Direction.right),
              ),
              const Spacer(),
              _ActionButton(
                label: 'OK',
                color: AppColors.confirm,
                onTap: () => onDirection(Direction.confirm),
              ),
              const SizedBox(width: 8),
              _ActionButton(
                label: 'Back',
                color: AppColors.textMuted,
                onTap: () => onDirection(Direction.cancel),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.12);
  }
}

class _DirButton extends StatelessWidget {
  const _DirButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceElevated,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: AppColors.primary),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: color),
          ),
        ),
      ),
    );
  }
}
