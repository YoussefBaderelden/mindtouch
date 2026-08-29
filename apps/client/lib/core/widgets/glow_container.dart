import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class GlowContainer extends StatelessWidget {
  const GlowContainer({
    super.key,
    required this.child,
    this.glowColor = AppColors.primary,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.all(20),
    this.active = false,
  });

  final Widget child;
  final Color glowColor;
  final double borderRadius;
  final EdgeInsets padding;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: AppColors.surface.withValues(alpha: 0.85),
        border: Border.all(
          color: active
              ? glowColor.withValues(alpha: 0.8)
              : AppColors.border.withValues(alpha: 0.6),
          width: active ? 2 : 1,
        ),
        boxShadow: active
            ? [
                BoxShadow(
                  color: glowColor.withValues(alpha: 0.35),
                  blurRadius: 24,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: glowColor.withValues(alpha: 0.12),
                  blurRadius: 48,
                  spreadRadius: 4,
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: child,
    );
  }
}
