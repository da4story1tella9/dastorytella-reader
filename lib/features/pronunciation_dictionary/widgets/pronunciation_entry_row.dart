/// Row for a single dictionary entry. Mirrors `.dict-entry` in
/// `docs/design-reference/app-mockups-secondary-batch.html`.
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../models/pronunciation_entry.dart';

class PronunciationEntryRow extends StatelessWidget {
  const PronunciationEntryRow({
    required this.entry,
    required this.onDelete,
    super.key,
  });

  final PronunciationEntry entry;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  entry.word,
                  style: AppTypography.bodyStrong.copyWith(fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  entry.pronunciation,
                  style: AppTypography.transcriptBody.copyWith(
                    color: AppColors.gold,
                    fontSize: 11,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  entry.contextLabel,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.inkFaint,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: onDelete,
            borderRadius: BorderRadius.circular(9),
            child: Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(
                Icons.delete_outline,
                size: 14,
                color: AppColors.inkFaint,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
