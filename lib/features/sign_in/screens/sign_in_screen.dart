/// Sign in screen. Mirrors
/// `docs/design-reference/app-mockups-core-batch2.html`.
///
/// No real OAuth/email auth exists yet (ARCHITECTURE.md §1) — tapping
/// any of the three auth methods just proceeds into the app, the same
/// as Onboarding's "Get started". That's a deliberate simplification,
/// not a bug: the whole app currently has no auth gate at all (see
/// OnboardingScreen's doc comment), so there's nothing real for these
/// buttons to connect to yet beyond "continue".
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared_widgets/app_icon_button.dart';
import '../../../shared_widgets/app_mark.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: <Widget>[
            AppIconButton(
              icon: Icons.arrow_back,
              onTap: () =>
                  context.canPop() ? context.pop() : context.go('/onboarding'),
            ),
            const SizedBox(height: 16),
            const AppMark(size: 56),
            const SizedBox(height: 20),
            Text(
              'Welcome back',
              style: AppTypography.screenTitle.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 8),
            Text(
              'Sign in to sync your library, voices, and reading position '
              'across devices.',
              style: AppTypography.body.copyWith(
                color: AppColors.inkSoft,
                fontSize: 12.5,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),
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
                onTap: () => context.canPop()
                    ? context.pop()
                    : context.push('/onboarding'),
                child: RichText(
                  text: TextSpan(
                    style: AppTypography.bodyStrong.copyWith(
                      color: AppColors.inkSoft,
                      fontSize: 12,
                    ),
                    children: const <InlineSpan>[
                      TextSpan(text: 'New here? '),
                      TextSpan(
                        text: 'Create an account',
                        style: TextStyle(color: AppColors.maroon),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: AppTypography.caption.copyWith(
                  color: AppColors.inkFaint,
                  fontSize: 10,
                  height: 1.6,
                  fontWeight: FontWeight.w500,
                ),
                children: const <InlineSpan>[
                  TextSpan(text: "By continuing, you agree to daStoryTella's "),
                  TextSpan(
                    text: 'Terms',
                    style: TextStyle(
                      color: AppColors.maroon,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                      color: AppColors.maroon,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(text: '.'),
                ],
              ),
            ),
          ],
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
        padding: const EdgeInsets.symmetric(vertical: 13),
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
