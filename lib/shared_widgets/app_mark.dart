/// Brand mark — the "d" logotype. Mirrors `.ob-mark` in
/// `docs/design-reference/app-mockups-core-batch2.html`, used on both
/// Onboarding and Sign In.
library;

import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

class AppMark extends StatelessWidget {
  const AppMark({this.size = 64, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.31),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[AppColors.goldSoft, AppColors.maroon],
        ),
      ),
      child: Text(
        'd',
        style: AppTypography.bookTitle.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: size * 0.4,
        ),
      ),
    );
  }
}
