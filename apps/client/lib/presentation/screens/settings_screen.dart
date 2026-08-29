import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/glow_container.dart';
import '../widgets/mind_touch_scaffold.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MindTouchScaffold(
      title: 'Settings',
      subtitle: 'Caregiver & device configuration',
      body: ListView(
        children: [
          _SettingsSection(
            title: 'Hardware',
            children: [
              _SettingsTile(
                icon: Icons.bluetooth_connected_rounded,
                title: 'MindTouch Cap',
                subtitle: 'MT-CAP-0042 · Connected',
                trailing: Icons.chevron_right_rounded,
              ),
              _SettingsTile(
                icon: Icons.tune_rounded,
                title: 'Recalibrate',
                subtitle: 'Last calibrated 3 days ago',
                trailing: Icons.chevron_right_rounded,
              ),
            ],
          ),
          _SettingsSection(
            title: 'Caregivers',
            children: [
              _SettingsTile(
                icon: Icons.person_add_rounded,
                title: 'Add Caregiver',
                subtitle: 'Invite via email or SMS',
                trailing: Icons.chevron_right_rounded,
              ),
              _SettingsTile(
                icon: Icons.security_rounded,
                title: 'Consent Scopes',
                subtitle: 'SOS alerts · Reminders',
                trailing: Icons.chevron_right_rounded,
              ),
            ],
          ),
          _SettingsSection(
            title: 'Smart Home',
            children: [
              _SettingsTile(
                icon: Icons.home_work_rounded,
                title: 'Home Assistant',
                subtitle: 'http://homeassistant.local:8123',
                trailing: Icons.chevron_right_rounded,
              ),
            ],
          ),
          _SettingsSection(
            title: 'Privacy',
            children: [
              _SettingsTile(
                icon: Icons.cloud_off_rounded,
                title: 'Cloud EEG Backup',
                subtitle: 'Off — data stays on device',
                trailing: Switch(value: false, onChanged: (_) {}),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textMuted,
                    letterSpacing: 1.5,
                  ),
            ),
          ),
          GlowContainer(
            padding: EdgeInsets.zero,
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final dynamic trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.primary.withValues(alpha: 0.1),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(subtitle),
      trailing: trailing is IconData
          ? Icon(trailing as IconData, color: AppColors.textMuted)
          : trailing,
    );
  }
}
