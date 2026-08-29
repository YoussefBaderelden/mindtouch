import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/models/surface.dart';

class SurfaceSelector extends StatelessWidget {
  const SurfaceSelector({
    super.key,
    required this.active,
    required this.onChanged,
  });

  final ControlSurface active;
  final ValueChanged<ControlSurface> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
      ),
      child: Row(
        children: ControlSurface.values.map((surface) {
          final isActive = surface == active;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(surface),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: isActive
                      ? const LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.secondary,
                          ],
                        )
                      : null,
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.35),
                            blurRadius: 16,
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  children: [
                    Icon(
                      _iconFor(surface),
                      size: 20,
                      color: isActive ? AppColors.void_ : AppColors.textMuted,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      surface.shortLabel,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: isActive ? AppColors.void_ : AppColors.textMuted,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1);
  }

  IconData _iconFor(ControlSurface surface) => switch (surface) {
        ControlSurface.phone => Icons.smartphone_rounded,
        ControlSurface.windows => Icons.desktop_windows_rounded,
        ControlSurface.smartHome => Icons.home_rounded,
        ControlSurface.medical => Icons.health_and_safety_rounded,
      };
}
