/// Row for a single download — icon, title, progress or status pill,
/// pause/resume action. Mirrors `.dl-row` in
/// `docs/design-reference/app-mockups-secondary-batch.html`.
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../models/download_item.dart';
import '../models/download_status.dart';

class DownloadRow extends StatelessWidget {
  const DownloadRow({
    required this.item,
    required this.onTogglePause,
    super.key,
  });

  final DownloadItem item;
  final VoidCallback onTogglePause;

  @override
  Widget build(BuildContext context) {
    final bool active = item.status == DownloadStatus.downloading ||
        item.status == DownloadStatus.paused;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon, size: 16, color: AppColors.maroon),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  item.title,
                  style: AppTypography.bodyStrong.copyWith(fontSize: 12.5),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (active) ...<Widget>[
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: item.progress,
                      minHeight: 4,
                      backgroundColor: AppColors.line,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        item.status == DownloadStatus.paused
                            ? AppColors.inkFaint
                            : AppColors.gold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(item.progress * 100).round()}% · '
                    '${(item.progress * item.totalMb).round()} MB of '
                    '${item.totalMb.round()} MB'
                    '${item.status == DownloadStatus.paused ? ' · Paused' : ''}',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.inkSoft,
                      fontSize: 10,
                    ),
                  ),
                ] else if (item.status == DownloadStatus.queued) ...<Widget>[
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: const LinearProgressIndicator(
                      value: 0.2,
                      minHeight: 4,
                      backgroundColor: AppColors.line,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.inkFaint,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.staticSubtitle ?? '',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.inkSoft,
                      fontSize: 10,
                    ),
                  ),
                ] else ...<Widget>[
                  const SizedBox(height: 4),
                  Text(
                    item.staticSubtitle ?? '',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.inkSoft,
                      fontSize: 10,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          if (active)
            InkWell(
              onTap: onTogglePause,
              customBorder: const CircleBorder(),
              child: Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceAlt,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  item.status == DownloadStatus.downloading
                      ? Icons.pause
                      : Icons.play_arrow_rounded,
                  size: 14,
                  color: AppColors.ink,
                ),
              ),
            )
          else
            _StatusPill(status: item.status),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final DownloadStatus status;

  @override
  Widget build(BuildContext context) {
    final bool ready = status == DownloadStatus.ready;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: ready ? AppColors.greenPale : AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        ready ? 'READY' : 'QUEUED',
        style: AppTypography.caption.copyWith(
          color: ready ? AppColors.green : AppColors.inkFaint,
          fontSize: 9,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
