/// Labeled, bordered card wrapping a settings group's rows, with a
/// divider between each. Mirrors `.settings-group`/`.settings-list` in
/// `docs/design-reference/app-mockups-core-batch1.html`.
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class SettingsGroupCard extends StatelessWidget {
  const SettingsGroupCard({
    required this.label,
    required this.children,
    super.key,
  });

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 2),
          child: Text(
            label.toUpperCase(),
            style: AppTypography.caption.copyWith(
              color: AppColors.inkFaint,
              fontSize: 10.5,
              letterSpacing: 0.9,
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.line),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              children: <Widget>[
                for (int i = 0; i < children.length; i++) ...<Widget>[
                  if (i > 0) const Divider(height: 1, color: AppColors.line),
                  children[i],
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
