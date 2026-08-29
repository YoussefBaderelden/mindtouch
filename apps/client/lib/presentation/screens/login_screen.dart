import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../widgets/auth/auth_screen_shell.dart';
import '../widgets/auth/luxe_form_controls.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    await ref.read(authProvider.notifier).login(
          _email.text.trim(),
          _password.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    return AuthScreenShell(
      title: 'Welcome back',
      subtitle: 'Sign in to link this phone to MindTouch cloud control and caregivers.',
      form: AuthFormCard(
        children: [
          LuxeTextField(
            controller: _email,
            label: 'Email',
            hint: 'you@example.com',
            icon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 18),
          LuxeTextField(
            controller: _password,
            label: 'Password',
            hint: 'Enter your password',
            icon: Icons.lock_outline_rounded,
            obscureText: _obscure,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
            suffix: IconButton(
              icon: Icon(
                _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              ),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
          if (auth.error != null) ...[
            const SizedBox(height: 16),
            AuthErrorBanner(
              message: auth.error!.replaceFirst('Exception: ', ''),
            ),
          ],
          const SizedBox(height: 24),
          LuxePrimaryButton(
            label: 'Sign in',
            icon: Icons.login_rounded,
            loading: auth.isLoading,
            onPressed: auth.isLoading ? null : _submit,
          ),
        ],
      ),
      footer: AuthFooterLink(
        prompt: 'New to MindTouch?',
        action: 'Create an account',
        onTap: () => context.go('/register'),
      ),
    );
  }
}
