import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../data/services/remote_control_service.dart';
import '../providers/app_providers.dart';
import '../providers/auth_provider.dart';
import 'control_screen.dart';
import 'settings_screen.dart';
import 'setup_screen.dart';

class ShellScreen extends ConsumerStatefulWidget {
  const ShellScreen({super.key});

  @override
  ConsumerState<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends ConsumerState<ShellScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrapShell());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused && Platform.isAndroid) {
      ref.read(platformServiceProvider).updateBubbleMessage('Listening in background');
    }
  }

  Future<void> _bootstrapShell() async {
    ref.read(remoteControlServiceProvider).connect();
    if (!Platform.isAndroid) return;

    final platform = ref.read(platformServiceProvider);
    await platform.startBackgroundService();
    await platform.showFloatingBubble('MindTouch active');
  }

  @override
  Widget build(BuildContext context) {
    final tab = ref.watch(activeTabProvider);

    return Scaffold(
      body: IndexedStack(
        index: tab,
        children: const [
          ControlScreen(),
          SetupScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: _MindTouchNavBar(
        currentIndex: tab,
        onTap: (index) => ref.read(activeTabProvider.notifier).state = index,
      ),
    );
  }
}

class _MindTouchNavBar extends StatelessWidget {
  const _MindTouchNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.95),
        border: Border(top: BorderSide(color: AppColors.border.withValues(alpha: 0.6))),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              _NavItem(
                icon: Icons.grid_view_rounded,
                label: 'Control',
                selected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: Icons.tune_rounded,
                label: 'Setup',
                selected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _NavItem(
                icon: Icons.person_rounded,
                label: 'Profile',
                selected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: selected
                ? AppColors.primary.withValues(alpha: 0.12)
                : Colors.transparent,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: selected ? AppColors.primary : AppColors.textMuted,
                size: 22,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: selected ? AppColors.primary : AppColors.textMuted,
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
