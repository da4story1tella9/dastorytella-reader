/// Assembles the token files (`app_colors.dart`, `app_typography.dart`)
/// into a Flutter [ThemeData] the app can consume via `Theme.of(context)`.
library;

import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.maroon,
        brightness: Brightness.light,
        primary: AppColors.maroon,
        secondary: AppColors.gold,
        surface: AppColors.surface,
      ),
      textTheme: const TextTheme(
        headlineMedium: AppTypography.screenTitle,
        titleLarge: AppTypography.bookTitle,
        bodyLarge: AppTypography.body,
        bodyMedium: AppTypography.transcriptBody,
        labelLarge: AppTypography.bodyStrong,
      ),
      dividerColor: AppColors.line,
      fontFamily: AppTypography.sansFamily,
    );
  }

  // Dark theme intentionally not defined yet — open decision, see
  // ARCHITECTURE.md §7. The initial mockup exploration used a full dark
  // theme for the Player screen and moved away from it; a proper dark
  // mode (if built) should be re-validated as a mockup first.
}
