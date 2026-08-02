/// Sign in / create account screen. Mirrors the Sign In mockup in
/// `docs/design-reference/app-mockups-core-batch2.html` — there's no
/// separate signup mockup, so this reuses the same layout for both
/// [AuthMode]s (a common real-world pattern; only the headline,
/// subtext, and bottom cross-link change).
///
/// No real OAuth/email auth exists yet (ARCHITECTURE.md §1) — tapping
/// any of the three provider buttons just proceeds into the app.
/// That's a deliberate simplification, not a bug: the whole app
/// currently has no auth gate at all (see OnboardingScreen's doc
/// comment), so there's nothing real for these buttons to connect to
/// yet beyond "continue".
///
/// Uses `SingleChildScrollView` + `Column`, not `ListView` — a plain
/// `ListView` forces its direct children to a tight full-width cross-
/// axis constraint, which silently stretches fixed-size widgets like
/// `AppMark`. `Column` doesn't have that gotcha, and this screen is
/// short and static with no need for `ListView`'s lazy-list machinery.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared_widgets/app_icon_button.dart';
import '../../../shared_widgets/app_mark.dart';
import '../models/auth_mode.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({required this.mode, super.key});

  final AuthMode mode;

  bool get _isSignIn => mode == AuthMode.signIn;

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
              // the three end up aligned to the widest label rather
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
                      onTap: () => context.go('/library'),
                    ),
                    const SizedBox(height: 10),
                    _AuthButton(
                      icon: Icons.g_mobiledata,
                      label: 'Continue with Google',
                      background: AppColors.surface,
                      foreground: AppColors.ink,
                      bordered: true,
                      onTap: () => context.go('/library'),
                    ),
                    const SizedBox(height: 10),
                    _AuthButton(
                      icon: Icons.mail_outline,
                      label: 'Continue with email',
                      background: AppColors.surface,
                      foreground: AppColors.ink,
                      bordered: true,
                      onTap: () => context.go('/library'),
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
