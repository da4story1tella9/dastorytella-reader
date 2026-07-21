/// Storage usage row — segmented bar (books/voices) with a legend and
/// a "Manage" link. Mirrors the storage `.settings-row` in
/// `docs/design-reference/app-mockups-core-batch1.html`.
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../models/storage_stats.dart';

class StorageRow extends StatelessWidget {
  const StorageRow({
    required this.stats,
    required this.onManageTap,
    super.key,
  });

  final StorageStats stats;
  final VoidCallback onManageTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onManageTap,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${stats.usedGb.toStringAsFixed(1)} GB of '
                  '${stats.totalGb.toStringAsFixed(0)} GB used',
                  style: AppTypography.bodyStrong.copyWith(fontSize: 13),
                ),
                Text(
                  'Manage ›',
                  style: AppTypography.body.copyWith(
                    color: AppColors.inkFaint,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: SizedBox(
                height: 6,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: (stats.booksFraction * 1000).round(),
                      child: const ColoredBox(color: AppColors.maroon),
                    ),
                    Expanded(
                      flex: (stats.voicesFraction * 1000).round(),
                      child: const ColoredBox(color: AppColors.gold),
                    ),
                    Expanded(
                      flex:
                          1000 -
                          (stats.booksFraction * 1000).round() -
                          (stats.voicesFraction * 1000).round(),
                      child: const ColoredBox(color: AppColors.line),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                const _LegendDot(color: AppColors.maroon),
                const SizedBox(width: 4),
                Text(
                  'Books',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.inkFaint,
                    fontSize: 9.5,
                  ),
                ),
                const SizedBox(width: 12),
                const _LegendDot(color: AppColors.gold),
                const SizedBox(width: 4),
                Text(
                  'Voices',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.inkFaint,
                    fontSize: 9.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
