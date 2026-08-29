import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/glow_container.dart';
import '../../core/widgets/neural_background.dart';
import '../../core/widgets/signal_meter.dart';
import '../providers/app_providers.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final step = ref.watch(_onboardingStepProvider);

    return Scaffold(
      body: NeuralBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MindTouch',
                  style: textTheme.displayMedium?.copyWith(
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: AppColors.gradientAccent,
                      ).createShader(const Rect.fromLTWH(0, 0, 280, 50)),
                  ),
                ).animate().fadeIn().slideX(begin: -0.05),
                const SizedBox(height: 8),
                Text(
                  'Neural control, reimagined.',
                  style: textTheme.bodyLarge,
                ).animate(delay: 100.ms).fadeIn(),
                const SizedBox(height: 32),
                Expanded(
                  child: _OnboardingStepContent(step: step),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    for (var i = 0; i < 4; i++)
                      Expanded(
                        child: Container(
                          height: 4,
                          margin: EdgeInsets.only(right: i < 3 ? 8 : 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            color: i <= step
                                ? AppColors.primary
                                : AppColors.border,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.void_,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      if (step < 3) {
                        ref.read(_onboardingStepProvider.notifier).state++;
                      } else {
                        ref.read(onboardingCompleteProvider.notifier).state = true;
                        context.go('/');
                      }
                    },
                    child: Text(step < 3 ? 'Continue' : 'Begin Calibration'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final _onboardingStepProvider = StateProvider<int>((ref) => 0);

class _OnboardingStepContent extends StatelessWidget {
  const _OnboardingStepContent({required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    final content = switch (step) {
      0 => _StepWelcome(),
      1 => _StepPermissions(),
      2 => _StepCalibration(),
      _ => _StepReady(),
    };

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: content,
    );
  }
}

class _StepWelcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlowContainer(
      key: const ValueKey('welcome'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 12),
          Text(
            'MindTouch turns imagined movement into real-world control — '
            'your phone, your PC, your home, all through one neural interface.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const Spacer(),
          _FeatureRow(
            icon: Icons.psychology_rounded,
            title: 'Imagine to navigate',
            subtitle: 'One interaction model everywhere',
          ),
          const SizedBox(height: 12),
          _FeatureRow(
            icon: Icons.bolt_rounded,
            title: 'Under 1.5s latency',
            subtitle: 'Edge-first AI inference',
          ),
          const SizedBox(height: 12),
          _FeatureRow(
            icon: Icons.shield_rounded,
            title: 'Safety built in',
            subtitle: 'SOS & caregiver alerts',
          ),
        ],
      ),
    );
  }
}

class _StepPermissions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlowContainer(
      key: const ValueKey('permissions'),
      glowColor: AppColors.secondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Permissions', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 12),
          Text(
            'MindTouch needs background access to stay connected to your cap.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          _PermissionTile(
            icon: Icons.bluetooth_rounded,
            title: 'Bluetooth',
            subtitle: 'Persistent cap connection',
          ),
          _PermissionTile(
            icon: Icons.notifications_active_rounded,
            title: 'Foreground Service',
            subtitle: 'Keeps listening alive',
          ),
          _PermissionTile(
            icon: Icons.accessibility_new_rounded,
            title: 'Accessibility',
            subtitle: 'Phone-wide control',
          ),
          _PermissionTile(
            icon: Icons.battery_charging_full_rounded,
            title: 'Battery Exemption',
            subtitle: 'Prevents OEM throttling',
          ),
        ],
      ),
    );
  }
}

class _StepCalibration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlowContainer(
      key: const ValueKey('calibration'),
      glowColor: AppColors.confirm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Calibration', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 12),
          Text(
            'Put on your cap. We\'ll guide you through imagining each direction.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          const SignalMeter(quality: 0.72, label: 'Live Signal Quality'),
          const Spacer(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.surfaceElevated,
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.arrow_upward_rounded, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Imagine moving your hand upward…',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textPrimary,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepReady extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlowContainer(
      key: const ValueKey('ready'),
      glowColor: AppColors.primary,
      active: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_rounded, size: 72, color: AppColors.primary)
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(
                begin: const Offset(0.95, 0.95),
                end: const Offset(1.05, 1.05),
                duration: 1200.ms,
              ),
          const SizedBox(height: 20),
          Text(
            'You\'re Ready',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Your neural profile is saved locally. Let\'s start controlling your world.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.primary.withValues(alpha: 0.12),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

class _PermissionTile extends StatelessWidget {
  const _PermissionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.secondary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Icon(Icons.check_circle_outline_rounded, color: AppColors.success, size: 20),
        ],
      ),
    );
  }
}
