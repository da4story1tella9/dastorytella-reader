/// Pill-shaped playback function toggle (speed, downloaded, sleep
/// timer, bookmark, share). Mirrors `.func-chip`/`.func-chip.on` in
/// `docs/design-reference/app-mockups-v2.html`.
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class FunctionChip extends StatelessWidget {
  const FunctionChip({
    required this.label,
    required this.onTap,
    this.icon,
    this.active = false,
    super.key,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final Color fg = active ? AppColors.maroon : AppColors.ink;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.maroonPale : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: active ? AppColors.maroon : AppColors.line),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (icon != null) ...<Widget>[
              Icon(icon, size: 13, color: fg),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: AppTypography.bodyStrong.copyWith(
                fontSize: 11,
                color: fg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
