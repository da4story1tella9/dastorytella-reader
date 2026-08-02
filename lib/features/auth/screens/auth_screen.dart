/// Sign in / create account screen. Mirrors the Sign In mockup in
/// `docs/design-reference/app-mockups-core-batch2.html` — there's no
/// separate signup mockup, so this reuses the same layout for both
/// [AuthMode]s (a common real-world pattern; only the headline,
/// subtext, and bottom cross-link change).
///
/// Deliberate deviation from the mockup: it renders "Continue with
/// email" as a fourth static button, same as Apple/Google. There's no
/// real form behind it, since the mockup set never designed one. Same
/// precedent as `AddEntryCard` (real text fields where the mockup only
/// had static "fake-input" boxes) — real auth needs a real form, so
/// this replaces that button with actual email/password fields wired
/// to Supabase (see docs/adr/0006-mobile-supabase-auth.md). Apple and
/// Google stay as the mockup drew them, but now correctly say they're
/// not set up yet instead of silently pretending to sign in — leaving
/// them faking success would be misleading once a real path exists
/// right next to them on the same screen.
///
/// Uses `SingleChildScrollView` + `Column`, not `ListView` — a plain
/// `ListView` forces its direct children to a tight full-width cross-
/// axis constraint, which silently stretches fixed-size widgets like
/// `AppMark`. `Column` doesn't have that gotcha, and this screen is
/// short and static with no need for `ListView`'s lazy-list machinery.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared_widgets/app_icon_button.dart';
import '../../../shared_widgets/app_mark.dart';
import '../models/auth_mode.dart';
import '../state/auth_controller.dart';
import '../state/auth_form_state.dart';
import '../state/auth_result.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({required this.mode, super.key});

  final AuthMode mode;

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  bool get _isSignIn => widget.mode == AuthMode.signIn;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showNotSetUpYet(String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sign in with $provider isn\'t set up yet.')),
    );
  }

  Future<void> _submit() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      return;
    }

    final AuthController controller = ref.read(authControllerProvider.notifier);
    final AuthResult result = _isSignIn
        ? await controller.signIn(email: email, password: password)
        : await controller.signUp(email: email, password: password);

    if (!mounted) {
      return;
    }
    switch (result) {
      case AuthResult.signedIn:
        context.go('/library');
      case AuthResult.confirmationRequired:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Check your email to confirm your account, then sign in.',
            ),
          ),
        );
        context.go('/sign-in');
      case AuthResult.failure:
        break; // Error is shown inline below the form.
    }
  }

  static final TextStyle _termsTextStyle = AppTypography.caption.copyWith(
    color: AppColors.inkFaint,
    fontSize: 10,
    height: 1.6,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle _termsLinkStyle = AppTypography.caption.copyWith(
    color: AppColors.maroon,
    fontSize: 10,
    height: 1.6,
    fontWeight: FontWeight.w700,
  );

  @override
  Widget build(BuildContext context) {
    final bool isSubmitting = ref.watch(
      authControllerProvider.select((AuthFormState s) => s.isSubmitting),
    );
    final String? errorMessage = ref.watch(
      authControllerProvider.select((AuthFormState s) => s.errorMessage),
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: AppIconButton(
                  icon: Icons.arrow_back,
                  onTap: () => context.canPop()
                      ? context.pop()
                      : context.go('/onboarding'),
                ),
              ),
              const SizedBox(height: 16),
              const AppMark(size: 56),
              const SizedBox(height: 20),
              Text(
                _isSignIn ? 'Welcome back' : 'Create your account',
                textAlign: TextAlign.center,
                style: AppTypography.screenTitle.copyWith(fontSize: 24),
              ),
              const SizedBox(height: 8),
              Text(
                _isSignIn
                    ? 'Sign in to sync your library, voices, and reading '
                        'position across devices.'
                    : 'Set up a free account to save your library, '
                        'voices, and reading position across devices.',
                textAlign: TextAlign.center,
                style: AppTypography.body.copyWith(
                  color: AppColors.inkSoft,
                  fontSize: 12.5,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 20),
              // IntrinsicWidth (not each button's own natural width) so
              // the two end up aligned to the widest label rather
              // than each hugging its own, different-length text —
              // compact as a group, not full-bleed, per review.
              IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _AuthButton(
                      icon: Icons.apple,
                      label: 'Continue with Apple',
                      background: const Color(0xFF141210),
                      foreground: Colors.white,
                      onTap: () => _showNotSetUpYet('Apple'),
                    ),
                    const SizedBox(height: 10),
                    _AuthButton(
                      icon: Icons.g_mobiledata,
                      label: 'Continue with Google',
                      background: AppColors.surface,
                      foreground: AppColors.ink,
                      bordered: true,
                      onTap: () => _showNotSetUpYet('Google'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: <Widget>[
                  const Expanded(child: Divider(color: AppColors.line)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'OR',
                      style: AppTypography.eyebrow.copyWith(
                        color: AppColors.inkFaint,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.line)),
                ],
              ),
              const SizedBox(height: 18),
              _AuthTextField(
                controller: _emailController,
                hint: 'Email',
                icon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              _AuthTextField(
                controller: _passwordController,
                hint: 'Password',
                icon: Icons.lock_outline,
                obscureText: _obscurePassword,
                onSubmitted: (_) => _submit(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 18,
                    color: AppColors.inkFaint,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              if (errorMessage != null) ...<Widget>[
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.errorPale,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    errorMessage,
                    style: AppTypography.body.copyWith(
                      color: AppColors.error,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 14),
              InkWell(
                onTap: isSubmitting ? null : _submit,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.maroon,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: isSubmitting
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          _isSignIn ? 'Sign in' : 'Create account',
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyStrong.copyWith(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 22),
              Center(
                child: InkWell(
                  onTap: () =>
                      context.push(_isSignIn ? '/sign-up' : '/sign-in'),
                  child: RichText(
                    text: TextSpan(
                      style: AppTypography.bodyStrong.copyWith(
                        color: AppColors.inkSoft,
                        fontSize: 12,
                      ),
                      children: <InlineSpan>[
                        TextSpan(
                          text: _isSignIn
                              ? 'New here? '
                              : 'Already have an account? ',
                        ),
                        TextSpan(
                          text: _isSignIn ? 'Create an account' : 'Sign in',
                          style: const TextStyle(color: AppColors.maroon),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              // Wrap of separate Text/InkWell segments, not RichText +
              // TextSpan.recognizer — a TapGestureRecognizer needs
              // explicit disposal to avoid leaking, which a
              // StatelessWidget can't do cleanly. This achieves the
              // same inline look without that lifecycle concern.
              Wrap(
                alignment: WrapAlignment.center,
                children: <Widget>[
                  Text(
                    "By continuing, you agree to daStoryTella's ",
                    style: _termsTextStyle,
                  ),
                  InkWell(
                    onTap: () => context.push('/terms'),
                    child: Text('Terms', style: _termsLinkStyle),
                  ),
                  Text(' and ', style: _termsTextStyle),
                  InkWell(
                    onTap: () => context.push('/privacy-policy'),
                    child: Text('Privacy Policy', style: _termsLinkStyle),
                  ),
                  Text('.', style: _termsTextStyle),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  const _AuthButton({
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
    required this.onTap,
    this.bordered = false,
  });

  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;
  final bool bordered;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 13),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(14),
          border: bordered ? Border.all(color: AppColors.line) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 16, color: foreground),
            const SizedBox(width: 10),
            Text(
              label,
              style: AppTypography.bodyStrong.copyWith(
                color: foreground,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthTextField extends StatelessWidget {
  const _AuthTextField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onSubmitted: onSubmitted,
        style: AppTypography.body.copyWith(color: AppColors.ink, fontSize: 13),
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 13,
          ),
          prefixIcon: Icon(icon, size: 17, color: AppColors.inkFaint),
          prefixIconConstraints: const BoxConstraints(minWidth: 38),
          suffixIcon: suffixIcon,
          hintText: hint,
          hintStyle: AppTypography.body.copyWith(
            color: AppColors.inkSoft,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
