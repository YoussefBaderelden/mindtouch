import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/app_config.dart';
import '../../core/theme/app_colors.dart';
import '../../platform/platform_service.dart';
import '../providers/app_providers.dart';
import '../providers/auth_provider.dart';
import '../providers/phone_control_provider.dart';
import '../widgets/mind_touch_scaffold.dart';
import '../widgets/profile/profile_widgets.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  DeviceProfile? _device;
  Map<String, dynamic> _permissions = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final platform = ref.read(platformServiceProvider);
    final profile = await platform.getDeviceProfile();
    final status = await platform.getPermissionStatus();
    if (mounted) {
      setState(() {
        _device = profile;
        _permissions = status;
      });
    }
  }

  Future<void> _logout() async {
    await ref.read(authProvider.notifier).logout();
    await resetAppFlow(ref);
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final phone = ref.watch(phoneControlProvider);
    final user = auth.user;
    final device = _device;

    final a11y = _permissions['accessibility'] == true || phone.accessibilityEnabled;
    final background = _permissions['background_service'] == true;

    return MindTouchScaffold(
      title: 'Profile',
      subtitle: 'Your account, device & assistive control',
      body: ListView(
        children: [
          ProfileHeroCard(
            displayName: user?.displayName ?? 'MindTouch User',
            email: user?.email ?? 'Not signed in',
            subtitle: 'NEURAL ASSISTIVE PROFILE',
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              ProfileStatChip(
                icon: Icons.accessibility_new_rounded,
                label: 'Accessibility',
                value: a11y ? 'Active' : 'Off',
                active: a11y,
              ),
              const SizedBox(width: 10),
              ProfileStatChip(
                icon: Icons.podcasts_rounded,
                label: 'Background',
                value: background ? 'Listening' : 'Stopped',
                active: background,
              ),
              const SizedBox(width: 10),
              ProfileStatChip(
                icon: Icons.link_rounded,
                label: 'Admin',
                value: phone.remoteConnected ? 'Linked' : 'Local',
                active: phone.remoteConnected,
              ),
            ],
          ),
          const SizedBox(height: 22),
          if (device != null) ...[
            const ProfileSectionHeader(title: 'This device'),
            ProfileSectionCard(
              children: [
                ProfileActionTile(
                  icon: Icons.phone_android_rounded,
                  title: device.model,
                  subtitle: '${device.platform.toUpperCase()} · ${device.osVersion}',
                  accent: AppColors.primary,
                ),
                ProfileActionTile(
                  icon: Icons.business_rounded,
                  title: device.manufacturer,
                  subtitle: 'ID ${device.deviceId}',
                  accent: AppColors.secondary,
                ),
              ],
            ),
          ],
          const ProfileSectionHeader(title: 'Control & safety'),
          ProfileSectionCard(
            children: [
              ProfileActionTile(
                icon: Icons.bubble_chart_rounded,
                title: 'Floating bubble',
                subtitle: 'Show status while using other apps',
                accent: AppColors.tertiary,
                onTap: () => ref
                    .read(platformServiceProvider)
                    .showFloatingBubble('MindTouch active'),
              ),
              ProfileActionTile(
                icon: Icons.verified_user_outlined,
                title: 'Permissions',
                subtitle: 'Accessibility, overlay & battery setup',
                accent: AppColors.confirm,
                onTap: () => context.go('/permissions'),
              ),
            ],
          ),
          const ProfileSectionHeader(title: 'Connection'),
          ProfileSectionCard(
            children: [
              ProfileActionTile(
                icon: Icons.cloud_outlined,
                title: 'Cloud API',
                subtitle: AppConfig.apiBase.isEmpty
                    ? 'Local development server'
                    : AppConfig.apiBase,
                accent: AppColors.primary,
              ),
            ],
          ),
          const ProfileSectionHeader(title: 'Account'),
          ProfileSectionCard(
            children: [
              ProfileActionTile(
                icon: Icons.logout_rounded,
                title: 'Sign out',
                subtitle: 'Clear session on this phone',
                accent: AppColors.danger,
                onTap: _logout,
                trailing: const Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.danger,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
