import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart' hide Direction;

import '../../domain/models/matrix_cell.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/glow_container.dart';

class MatrixCellWidget extends StatelessWidget {
  const MatrixCellWidget({
    super.key,
    required this.cell,
    required this.selected,
    required this.onTap,
    this.compact = false,
  });

  final MatrixCell cell;
  final bool selected;
  final VoidCallback onTap;
  final bool compact;

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
    if (compact) return _buildCompact(context);
    return _buildFull(context);
  }

  Widget _buildCompact(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return RepaintBoundary(
      child: GestureDetector(
        onTap: onTap,
        child: GlowContainer(
          active: selected,
          glowColor: _accent,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          borderRadius: 18,
          child: Row(
            children: [
              _IconBadge(
                accent: _accent,
                selected: selected,
                icon: cell.icon,
                size: 28,
                iconSize: 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  cell.label,
                  style: textTheme.labelLarge?.copyWith(
                    color: selected
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (selected)
                Icon(
                  Icons.radio_button_checked_rounded,
                  color: _accent,
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFull(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const padding = 18.0;
    const iconSize = 44.0;

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
            padding: const EdgeInsets.all(padding),
            borderRadius: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _IconBadge(
                      accent: _accent,
                      selected: selected,
                      icon: cell.icon,
                      size: iconSize,
                      iconSize: 24,
                    ),
                    const Spacer(),
                    if (selected)
                      Icon(
                        Icons.radio_button_checked_rounded,
                        color: _accent,
                        size: 18,
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
                    color: selected
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  cell.subtitle,
                  style: textTheme.bodySmall,
                  maxLines: 1,
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

class _IconBadge extends StatelessWidget {
  const _IconBadge({
    required this.accent,
    required this.selected,
    required this.icon,
    required this.size,
    required this.iconSize,
  });

  final Color accent;
  final bool selected;
  final IconData icon;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            accent.withValues(alpha: 0.25),
            accent.withValues(alpha: 0.08),
          ],
        ),
        border: Border.all(
          color: accent.withValues(alpha: selected ? 0.6 : 0.25),
        ),
      ),
      child: Icon(icon, color: accent, size: iconSize),
    );
  }
}
