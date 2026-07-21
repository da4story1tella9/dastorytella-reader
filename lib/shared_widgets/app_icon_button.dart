/// Square outlined icon button. Mirrors `.icon-btn` in
/// `docs/design-reference/app-mockups-v2.html`.
library;

import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({required this.icon, required this.onTap, super.key});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.line),
        ),
        child: Icon(icon, size: 16, color: AppColors.ink),
      ),
    );
  }
}
