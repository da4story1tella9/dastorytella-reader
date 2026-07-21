/// A single tappable settings row — icon, title, optional subtitle,
/// optional trailing value, chevron. Mirrors `.settings-row` in
/// `docs/design-reference/app-mockups-core-batch1.html`.
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../models/settings_item.dart';

class SettingsRow extends StatelessWidget {
  const SettingsRow({required this.item, required this.onTap, super.key});

  final SettingsItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          children: <Widget>[
            Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(item.icon, size: 15, color: AppColors.maroon),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    item.title,
                    style: AppTypography.bodyStrong.copyWith(fontSize: 13),
                  ),
                  if (item.subtitle != null) ...<Widget>[
                    const SizedBox(height: 1),
                    Text(
                      item.subtitle!,
                      style: AppTypography.body.copyWith(
                        color: AppColors.inkSoft,
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (item.value != null) ...<Widget>[
              Text(
                item.value!,
                style: AppTypography.body.copyWith(
                  color: AppColors.inkFaint,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 2),
            ],
            const Icon(
              Icons.chevron_right,
              size: 16,
              color: AppColors.inkFaint,
            ),
          ],
        ),
      ),
    );
  }
}
