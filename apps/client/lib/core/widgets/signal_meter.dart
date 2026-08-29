import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_colors.dart';

class SignalMeter extends StatelessWidget {
  const SignalMeter({
    super.key,
    required this.quality,
    this.label = 'Signal',
  });

  final double quality;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(
              '${(quality * 100).round()}%',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            height: 6,
            child: Stack(
              children: [
                Container(color: AppColors.border),
                FractionallySizedBox(
                  widthFactor: quality.clamp(0.0, 1.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: AppColors.gradientAccent,
                      ),
                    ),
                  ),
                )
                    .animate()
                    .shimmer(
                      duration: 1800.ms,
                      color: Colors.white.withValues(alpha: 0.25),
                    ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
