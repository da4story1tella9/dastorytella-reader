/// Design tokens — typography.
///
/// Two-role type system:
/// - Fraunces (serif): book titles, screen headers, anything that should
///   carry literary/editorial weight
/// - Manrope (sans): UI chrome — buttons, labels, body copy, navigation
///
/// Fonts must be added under `assets/fonts/` and declared in `pubspec.yaml`
/// before this will resolve — see pubspec.yaml `fonts:` section.
library;

import 'package:flutter/material.dart';

class AppTypography {
  AppTypography._();

  static const String serifFamily = 'Fraunces';
  static const String sansFamily = 'Manrope';

  static const TextStyle screenTitle = TextStyle(
    fontFamily: serifFamily,
    fontWeight: FontWeight.w600,
    fontSize: 26,
  );

  static const TextStyle bookTitle = TextStyle(
    fontFamily: serifFamily,
    fontWeight: FontWeight.w600,
    fontSize: 19,
  );

  static const TextStyle transcriptBody = TextStyle(
    fontFamily: serifFamily,
    fontWeight: FontWeight.w400,
    fontSize: 15,
    height: 1.6,
  );

  static const TextStyle bodyStrong = TextStyle(
    fontFamily: sansFamily,
    fontWeight: FontWeight.w700,
    fontSize: 13,
  );

  static const TextStyle body = TextStyle(
    fontFamily: sansFamily,
    fontWeight: FontWeight.w500,
    fontSize: 13,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: sansFamily,
    fontWeight: FontWeight.w600,
    fontSize: 11,
  );

  static const TextStyle eyebrow = TextStyle(
    fontFamily: sansFamily,
    fontWeight: FontWeight.w800,
    fontSize: 10.5,
    letterSpacing: 0.9,
  );
}
