/// Design tokens — color.
///
/// Source of truth: the HTML mockups in `docs/design-reference/`.
/// Any palette change should be made there first, then mirrored here,
/// so the two never drift apart (see CONTRIBUTING.md).
///
/// Palette principle: warm paper base, maroon + gold as *accent*,
/// never as full-screen wash. See ADR context in project history —
/// the initial dark full-bleed design was revised for usability.
library;

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Base surfaces
  static const Color background = Color(0xFFFAF7F1);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFF2EDE3);

  // Text
  static const Color ink = Color(0xFF251D18);
  static const Color inkSoft = Color(0xFF71675A);
  static const Color inkFaint = Color(0xFFA79C8C);

  // Structure
  static const Color line = Color(0xFFEAE3D6);

  // Accent — gold (used sparingly: active states, badges, highlights)
  static const Color gold = Color(0xFFC98A2E);
  static const Color goldSoft = Color(0xFFF0CE95);
  static const Color goldPale = Color(0xFFFBEDD3);

  // Accent — maroon (used sparingly: primary actions, brand mark)
  static const Color maroon = Color(0xFF7A2E34);
  static const Color maroonPale = Color(0xFFF5E7E6);

  // Status
  static const Color green = Color(0xFF5C8A5C);
  static const Color greenPale = Color(0xFFE7F0E4);
  static const Color blue = Color(0xFF4A6FA5);
  static const Color bluePale = Color(0xFFE9EFF7);
}
