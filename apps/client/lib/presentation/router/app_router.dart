import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/app_providers.dart';
import '../providers/auth_provider.dart';
import '../screens/login_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/permissions_screen.dart';
import '../screens/register_screen.dart';
import '../screens/shell_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final bootstrap = ref.watch(bootstrapProvider);
  final auth = ref.watch(authProvider);
  final onboardingComplete = ref.watch(onboardingCompleteProvider);
  final permissionsComplete = ref.watch(permissionsCompleteProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      if (bootstrap.isLoading || auth.isLoading) return null;

      final loc = state.matchedLocation;
      final authed = auth.isAuthenticated;
      final onAuth = loc == '/login' || loc == '/register';

      if (!authed && !onAuth) return '/login';
      if (authed && onAuth) {
        if (!permissionsComplete) return '/permissions';
        if (!onboardingComplete) return '/onboarding';
        return '/';
      }
      if (authed && !permissionsComplete && loc != '/permissions') {
        return '/permissions';
      }
      if (authed &&
          permissionsComplete &&
          !onboardingComplete &&
          loc != '/onboarding') {
        return '/onboarding';
      }
      if (authed && permissionsComplete && onboardingComplete && loc == '/onboarding') {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/permissions',
        builder: (context, state) => const PermissionsScreen(),
      ),
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
