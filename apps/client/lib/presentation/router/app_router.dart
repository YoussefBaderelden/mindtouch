import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/app_providers.dart';
import '../screens/onboarding_screen.dart';
import '../screens/shell_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final onboardingComplete = ref.watch(onboardingCompleteProvider);

  return GoRouter(
    initialLocation: onboardingComplete ? '/' : '/onboarding',
    redirect: (context, state) {
      final complete = ref.read(onboardingCompleteProvider);
      final onOnboarding = state.matchedLocation == '/onboarding';

      if (!complete && !onOnboarding) return '/onboarding';
      if (complete && onOnboarding) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const ShellScreen(),
      ),
    ],
  );
});
