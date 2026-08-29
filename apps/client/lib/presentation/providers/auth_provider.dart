import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/auth_service.dart';
import '../../platform/platform_service.dart';

final platformServiceProvider = Provider<PlatformService>((ref) {
  return PlatformService();
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.read(platformServiceProvider));
});

class AuthState {
  const AuthState({
    this.user,
    this.isLoading = true,
    this.error,
  });

  final AuthUser? user;
  final bool isLoading;
  final String? error;

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    AuthUser? user,
    bool? isLoading,
    String? error,
    bool clearUser = false,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    _loadStored();
    return const AuthState(isLoading: true);
  }

  Future<void> _loadStored() async {
    try {
      final user = await ref.read(authServiceProvider).getStoredUser();
      state = AuthState(user: user, isLoading: false);
    } catch (_) {
      state = const AuthState(isLoading: false);
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await ref.read(authServiceProvider).login(
            email: email,
            password: password,
          );
      state = AuthState(user: user, isLoading: false);
    } catch (e) {
      state = AuthState(isLoading: false, error: e.toString());
    }
  }

  Future<void> register(String email, String password, String name) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await ref.read(authServiceProvider).register(
            email: email,
            password: password,
            displayName: name,
          );
      state = AuthState(user: user, isLoading: false);
    } catch (e) {
      state = AuthState(isLoading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    await ref.read(authServiceProvider).logout();
    state = const AuthState(isLoading: false);
  }
}
