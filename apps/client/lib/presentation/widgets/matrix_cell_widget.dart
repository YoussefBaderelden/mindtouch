import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../domain/models/matrix_cell.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/glow_container.dart';

class MatrixCellWidget extends StatelessWidget {
  const MatrixCellWidget({
    super.key,
    required this.cell,
    required this.selected,
    required this.onTap,
  });

  final MatrixCell cell;
  final bool selected;
  final VoidCallback onTap;

  Color get _accent {
    if (cell.accentColor != null) return cell.accentColor!;
    return switch (cell.kind) {
      MatrixCellKind.confirm => AppColors.confirm,
      MatrixCellKind.cancel => AppColors.textMuted,
      MatrixCellKind.sos => AppColors.danger,
      _ => AppColors.primary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return RepaintBoundary(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedScale(
          scale: selected ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutBack,
          child: GlowContainer(
            active: selected,
            glowColor: _accent,
            padding: const EdgeInsets.all(18),
            borderRadius: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: LinearGradient(
                          colors: [
                            _accent.withValues(alpha: 0.25),
                            _accent.withValues(alpha: 0.08),
                          ],
                        ),
                        border: Border.all(
                          color: _accent.withValues(alpha: selected ? 0.6 : 0.25),
                        ),
                      ),
                      child: Icon(cell.icon, color: _accent, size: 24),
                    ),
                    const Spacer(),
                    if (selected)
                      Icon(
                        Icons.radio_button_checked_rounded,
                        color: _accent,
                        size: 20,
                      )
                          .animate()
                          .fadeIn(duration: 200.ms)
                          .scale(begin: const Offset(0.5, 0.5)),
                  ],
                ),
                const Spacer(),
                Text(
                  cell.label,
                  style: textTheme.titleLarge?.copyWith(
                    color: selected ? AppColors.textPrimary : AppColors.textSecondary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  cell.subtitle,
                  style: textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
