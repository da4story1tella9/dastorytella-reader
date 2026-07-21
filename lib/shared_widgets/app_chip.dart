/// Pill-shaped filter chip. Mirrors `.chip`/`.chip.active` in
/// `docs/design-reference/app-mockups-v2.html`.
library;

import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

class AppChip extends StatelessWidget {
  const AppChip({
    required this.label,
    required this.active,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
        decoration: BoxDecoration(
          color: active ? AppColors.maroon : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? AppColors.maroon : AppColors.line,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.bodyStrong.copyWith(
            fontSize: 11.5,
            color: active ? Colors.white : AppColors.inkSoft,
          ),
        ),
      ),
    );
  }
}
