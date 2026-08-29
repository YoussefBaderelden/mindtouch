import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';

class ConfirmationOverlay extends StatelessWidget {
  const ConfirmationOverlay({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    required this.accentColor,
    required this.onDismiss,
  });

  final String title;
  final String message;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.void_.withValues(alpha: 0.75),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.surfaceElevated,
                AppColors.surface,
              ],
            ),
            border: Border.all(color: accentColor.withValues(alpha: 0.5), width: 2),
            boxShadow: [
              BoxShadow(
                color: accentColor.withValues(alpha: 0.25),
                blurRadius: 40,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      accentColor.withValues(alpha: 0.3),
                      accentColor.withValues(alpha: 0.1),
                    ],
                  ),
                ),
                child: Icon(icon, color: accentColor, size: 36),
              )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scale(
                    begin: const Offset(0.95, 0.95),
                    end: const Offset(1.05, 1.05),
                    duration: 800.ms,
                  ),
              const SizedBox(height: 20),
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: onDismiss,
                child: const Text('Dismiss'),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 250.ms).scale(
              begin: const Offset(0.9, 0.9),
              curve: Curves.easeOutBack,
            ),
      ),
    );
  }
}
