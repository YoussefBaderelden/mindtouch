import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kOnboarding = 'mt_onboarding_complete';
const _kPermissions = 'mt_permissions_complete';

final bootstrapProvider = FutureProvider<void>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  ref.read(onboardingCompleteProvider.notifier).state =
      prefs.getBool(_kOnboarding) ?? false;
  ref.read(permissionsCompleteProvider.notifier).state =
      prefs.getBool(_kPermissions) ?? false;
});

final onboardingCompleteProvider = StateProvider<bool>((ref) => false);

final permissionsCompleteProvider = StateProvider<bool>((ref) => false);

final activeTabProvider = StateProvider<int>((ref) => 0);

Future<void> markOnboardingComplete(WidgetRef ref) async {
  ref.read(onboardingCompleteProvider.notifier).state = true;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_kOnboarding, true);
}

Future<void> markPermissionsComplete(WidgetRef ref) async {
  ref.read(permissionsCompleteProvider.notifier).state = true;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_kPermissions, true);
}

Future<void> resetAppFlow(WidgetRef ref) async {
  ref.read(onboardingCompleteProvider.notifier).state = false;
  ref.read(permissionsCompleteProvider.notifier).state = false;
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_kOnboarding);
  await prefs.remove(_kPermissions);
}
