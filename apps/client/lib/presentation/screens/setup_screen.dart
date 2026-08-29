import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/glow_container.dart';
import '../providers/phone_control_provider.dart';
import '../widgets/mind_touch_scaffold.dart';

class SetupScreen extends ConsumerWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phoneControl = ref.watch(phoneControlProvider);

    return MindTouchScaffold(
      title: 'Background Setup',
      subtitle: 'Keep MindTouch alive & control your phone',
      body: ListView(
        children: [
          _SetupStep(
            step: 1,
            title: 'Enable Accessibility Service',
            subtitle: 'Required for taps, scrolls, typing on any app',
            done: phoneControl.accessibilityEnabled,
            icon: Icons.accessibility_new_rounded,
            onFix: () => ref
                .read(phoneControlProvider.notifier)
                .openAccessibilitySettings(),
          ),
          _SetupStep(
            step: 2,
            title: 'Cloud / Admin Connected',
            subtitle: phoneControl.remoteConnected
                ? 'Linked to ${AppConfig.apiBase}'
                : 'Deploy to Vercel — see DEPLOY.md',
            done: phoneControl.remoteConnected,
            icon: Icons.cloud_done_rounded,
          ),
          _SetupStep(
            step: 3,
            title: 'Disable Battery Optimization',
            subtitle: 'Prevents Samsung/Xiaomi from killing the service',
            done: false,
            icon: Icons.battery_charging_full_rounded,
          ),
          _SetupStep(
            step: 4,
            title: 'Allow Background Bluetooth',
            subtitle: 'Maintains persistent cap connection',
            done: false,
            icon: Icons.bluetooth_rounded,
          ),
          if (phoneControl.logs.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              'RECENT ACTIONS',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textMuted,
                    letterSpacing: 1.5,
                  ),
            ),
            const SizedBox(height: 10),
            ...phoneControl.logs.take(8).map(
                  (log) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: GlowContainer(
                      padding: const EdgeInsets.all(12),
                      glowColor: log.success ? AppColors.success : AppColors.danger,
                      child: Row(
                        children: [
                          Icon(
                            log.success ? Icons.check_circle : Icons.error,
                            color: log.success ? AppColors.success : AppColors.danger,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${log.action.label} (${log.source})',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          ],
        ],
      ),
    );
  }
}

class _SetupStep extends StatelessWidget {
  const _SetupStep({
    required this.step,
    required this.title,
    required this.subtitle,
    required this.done,
    required this.icon,
    this.onFix,
  });

  final int step;
  final String title;
  final String subtitle;
  final bool done;
  final IconData icon;
  final VoidCallback? onFix;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GlowContainer(
        active: !done,
        glowColor: done ? AppColors.success : AppColors.warning,
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (done ? AppColors.success : AppColors.warning)
                    .withValues(alpha: 0.15),
              ),
              child: Icon(
                done ? Icons.check_rounded : icon,
                color: done ? AppColors.success : AppColors.warning,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Step $step',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            if (!done && onFix != null)
              TextButton(
                onPressed: onFix,
                child: const Text('Fix'),
              ),
          ],
        ),
      ),
    );
  }
}
