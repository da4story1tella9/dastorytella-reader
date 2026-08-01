/// Download manager screen — storage summary and in-progress/
/// downloaded lists. Mirrors
/// `docs/design-reference/app-mockups-secondary-batch.html`.
///
/// Reuses Settings' `mockStorageStats` for the ring/legend rather than
/// inventing separate numbers, so the two screens' storage figures
/// can't drift out of sync (same reasoning as the shared now-playing
/// state). The in-progress download genuinely ticks and can be
/// paused/resumed — see `state/download_manager_providers.dart`.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared_widgets/app_icon_button.dart';
import '../../settings/state/mock_settings_data.dart';
import '../models/download_item.dart';
import '../models/download_status.dart';
import '../state/download_manager_providers.dart';
import '../widgets/download_row.dart';
import '../widgets/storage_ring.dart';

class DownloadManagerScreen extends ConsumerWidget {
  const DownloadManagerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<DownloadItem> items = ref.watch(downloadItemsProvider);
    final DownloadManagerController controller = ref.read(
      downloadItemsProvider.notifier,
    );

    final List<DownloadItem> inProgress = items
        .where(
          (DownloadItem d) =>
              d.status == DownloadStatus.downloading ||
              d.status == DownloadStatus.paused ||
              d.status == DownloadStatus.queued,
        )
        .toList();
    final List<DownloadItem> downloaded = items
        .where((DownloadItem d) => d.status == DownloadStatus.ready)
        .toList();

    final double booksGb =
        mockStorageStats.totalGb * mockStorageStats.booksFraction;
    final double voicesGb =
        mockStorageStats.totalGb * mockStorageStats.voicesFraction;
    final double freeGb = mockStorageStats.totalGb - mockStorageStats.usedGb;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                AppIconButton(
                  icon: Icons.arrow_back,
                  onTap: () => context.canPop()
                      ? context.pop()
                      : context.go('/settings'),
                ),
                const Text(
                  'Downloads',
                  style: TextStyle(
                    fontFamily: AppTypography.serifFamily,
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
                AppIconButton(icon: Icons.more_horiz, onTap: () {}),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.line),
              ),
              child: Row(
                children: <Widget>[
                  StorageRing(
                    booksFraction: mockStorageStats.booksFraction,
                    voicesFraction: mockStorageStats.voicesFraction,
                    centerLabel:
                        '${mockStorageStats.usedGb.toStringAsFixed(1)}GB',
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _LegendRow(
                          color: AppColors.maroon,
                          label:
                              'Offline books · ${booksGb.toStringAsFixed(1)} GB',
                        ),
                        const SizedBox(height: 5),
                        _LegendRow(
                          color: AppColors.gold,
                          label:
                              'Voice packs · ${voicesGb.toStringAsFixed(1)} GB',
                        ),
                        const SizedBox(height: 5),
                        _LegendRow(
                          color: AppColors.line,
                          label: '${freeGb.toStringAsFixed(1)} GB free of '
                              '${mockStorageStats.totalGb.toStringAsFixed(0)} GB',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 4, left: 2),
              child: Text('IN PROGRESS', style: AppTypography.eyebrow),
            ),
            for (final DownloadItem item in inProgress)
              DownloadRow(
                item: item,
                onTogglePause: () => controller.togglePause(item.id),
              ),
            const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 4, left: 2),
              child: Text('DOWNLOADED', style: AppTypography.eyebrow),
            ),
            for (final DownloadItem item in downloaded)
              DownloadRow(item: item, onTogglePause: () {}),
          ],
        ),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: AppTypography.body.copyWith(
              color: AppColors.inkSoft,
              fontSize: 10.5,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
