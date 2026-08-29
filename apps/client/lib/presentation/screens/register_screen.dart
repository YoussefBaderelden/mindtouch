import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth/auth_screen_shell.dart';
import '../widgets/auth/luxe_form_controls.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    await ref.read(authProvider.notifier).register(
          _email.text.trim(),
          _password.text,
          _name.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    return AuthScreenShell(
      title: 'Create your account',
      subtitle: 'Register your device so caregivers and neural control stay connected.',
      accentColor: AppColors.secondary,
      form: AuthFormCard(
        accentColor: AppColors.secondary,
        children: [
          LuxeTextField(
            controller: _name,
            label: 'Full name',
            hint: 'How should we address you?',
            icon: Icons.person_outline_rounded,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 18),
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
            hint: 'Minimum 6 characters',
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
            label: 'Create account',
            icon: Icons.person_add_alt_1_rounded,
            loading: auth.isLoading,
            onPressed: auth.isLoading ? null : _submit,
          ),
        ],
      ),
      footer: AuthFooterLink(
        prompt: 'Already registered?',
        action: 'Sign in',
        onTap: () => context.go('/login'),
      ),
    );
  }
}
