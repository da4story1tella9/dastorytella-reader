/// Onboarding welcome screen. Mirrors
/// `docs/design-reference/app-mockups-core-batch2.html`.
///
/// The mockup's 3-dot indicator implies a multi-step carousel, but
/// only this one welcome step is designed — the dots are kept as a
/// static visual matching the mockup rather than faked into a real
/// carousel with undesigned steps.
///
/// This IS the app's actual startup gate now (ADR-0008,
/// core/router/app_router.dart's `redirect` callback) — a signed-out
/// user lands here before anything else, regardless of what URL they
/// might otherwise have opened.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared_widgets/app_mark.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const AppMark(),
                const SizedBox(height: 26),
                Text(
                  'Every book,\nread the way it deserves.',
                  textAlign: TextAlign.center,
                  style: AppTypography.screenTitle.copyWith(
                    fontSize: 25,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Upload anything — a novel, a PDF, your own draft — and '
                  'hear it read back with real tone, real pacing, and '
                  "voices that don't flatten who's speaking.",
                  textAlign: TextAlign.center,
                  style: AppTypography.body.copyWith(
                    color: AppColors.inkSoft,
                    fontSize: 12.5,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 30),
                // Fixed/content-sized, not full-width — the mockup's CSS
                // makes this span 100%, but a full-bleed CTA looked wrong
                // in practice (per review) once built and seen live.
                InkWell(
                  onTap: () => context.push('/sign-up'),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.maroon,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Get started',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyStrong.copyWith(
                        color: Colors.white,
                        fontSize: 13.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                InkWell(
                  onTap: () => context.push('/sign-in'),
                  child: RichText(
                    text: TextSpan(
                      style: AppTypography.bodyStrong.copyWith(
                        color: AppColors.inkSoft,
                        fontSize: 12,
                      ),
                      children: const <InlineSpan>[
                        TextSpan(text: 'Already have an account? '),
                        TextSpan(
                          text: 'Sign in',
                          style: TextStyle(color: AppColors.maroon),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _Dot(active: true),
                    SizedBox(width: 6),
                    _Dot(),
                    SizedBox(width: 6),
                    _Dot(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({this.active = false});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: active ? 18 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: active ? AppColors.maroon : AppColors.line,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
