import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/glow_container.dart';
import '../../core/widgets/neural_background.dart';
import '../../platform/platform_service.dart';
import '../../platform/phone_control_platform.dart';
import '../providers/app_providers.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth/luxe_form_controls.dart';

class PermissionsScreen extends ConsumerStatefulWidget {
  const PermissionsScreen({super.key});

  @override
  ConsumerState<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends ConsumerState<PermissionsScreen>
    with WidgetsBindingObserver {
  Timer? _pollTimer;
  Map<String, dynamic> _status = {};
  DeviceProfile? _device;
  bool _starting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load();
    _pollTimer = Timer.periodic(const Duration(seconds: 2), (_) => _refresh());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pollTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refresh();
  }

  Future<void> _load() async {
    final platform = ref.read(platformServiceProvider);
    _device = await platform.getDeviceProfile();
    await _refresh();
    if (mounted) setState(() {});
  }

  Future<void> _refresh() async {
    final platform = ref.read(platformServiceProvider);
    final status = await platform.getPermissionStatus();
    if (mounted) setState(() => _status = status);
  }

  bool get _accessibility => _status['accessibility'] == true;
  bool get _overlay => _status['overlay'] == true;
  bool get _battery => _status['battery_exemption'] == true;
  bool get _background => _status['background_service'] == true;

  bool get _allReady =>
      !Platform.isAndroid ||
      (_accessibility && _overlay && _battery && _background);

  Future<void> _finish() async {
    if (!_allReady) return;
    await markPermissionsComplete(ref);
  }

  Future<void> _startBackground() async {
    setState(() => _starting = true);
    final platform = ref.read(platformServiceProvider);
    await platform.startBackgroundService();
    await platform.showFloatingBubble('MindTouch active');
    await _refresh();
    if (mounted) setState(() => _starting = false);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final device = _device;

    return Scaffold(
      body: NeuralBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Enable access', style: textTheme.displaySmall),
                const SizedBox(height: 8),
                Text(
                  'MindTouch runs in the background like TalkBack — with a floating status bubble.',
                  style: textTheme.bodyMedium,
                ),
                if (device != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    '${device.manufacturer} ${device.model} · ${device.osVersion}',
                    style: textTheme.labelSmall?.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: [
                      _PermCard(
                        icon: Icons.accessibility_new_rounded,
                        title: 'Accessibility service',
                        subtitle: 'Controls scroll, tap, swipe across all apps',
                        granted: _accessibility,
                        onEnable: () async {
                          await createPhoneControlService()
                              .openAccessibilitySettings();
                        },
                      ),
                      _PermCard(
                        icon: Icons.bubble_chart_rounded,
                        title: 'Floating bubble',
                        subtitle: 'Shows status & messages while you use other apps',
                        granted: _overlay,
                        onEnable: () => ref
                            .read(platformServiceProvider)
                            .requestOverlayPermission(),
                      ),
                      _PermCard(
                        icon: Icons.battery_charging_full_rounded,
                        title: 'Battery exemption',
                        subtitle: 'Prevents Android from stopping background control',
                        granted: _battery,
                        onEnable: () => ref
                            .read(platformServiceProvider)
                            .requestBatteryOptimization(),
                      ),
                      _PermCard(
                        icon: Icons.notifications_active_rounded,
                        title: 'Background listening',
                        subtitle: 'Keeps neural commands alive when screen is off',
                        granted: _background,
                        onEnable: _startBackground,
                        loading: _starting,
                      ),
                    ],
                  ),
                ),
                LuxePrimaryButton(
                  label: _allReady ? 'Continue' : 'Grant all permissions above',
                  onPressed: _allReady ? _finish : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PermCard extends StatelessWidget {
  const _PermCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.granted,
    required this.onEnable,
    this.loading = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool granted;
  final VoidCallback onEnable;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlowContainer(
        glowColor: granted ? AppColors.success : AppColors.warning,
        active: granted,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: granted ? AppColors.success : AppColors.warning),
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
            if (granted)
              const Icon(Icons.check_circle_rounded, color: AppColors.success)
            else
              TextButton(
                onPressed: loading ? null : onEnable,
                child: loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Enable'),
              ),
          ],
        ),
      ),
    );
  }
}
