/// A single row in the chapter list. Mirrors `.chapter-row` in
/// `docs/design-reference/app-mockups-core-batch1.html`.
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

/// Presentation-only status — computed by the screen from comparing a
/// chapter's index against the shared now-playing state's current
/// chapter, not stored on any model.
enum ChapterRowStatus { done, current, upcoming }

class ChapterRow extends StatelessWidget {
  const ChapterRow({
    required this.index,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.onTap,
    super.key,
  });

  final int index;
  final String title;
  final String subtitle;
  final ChapterRowStatus status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool isDone = status == ChapterRowStatus.done;
    final bool isCurrent = status == ChapterRowStatus.current;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.line)),
        ),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 26,
              child: Text(
                '$index',
                textAlign: TextAlign.center,
                style: AppTypography.bodyStrong.copyWith(
                  fontSize: 12,
                  color: isCurrent ? AppColors.maroon : AppColors.inkFaint,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    title,
                    style: AppTypography.bodyStrong.copyWith(
                      fontSize: 13,
                      color: isDone ? AppColors.inkFaint : AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: AppTypography.body.copyWith(
                      color: AppColors.inkSoft,
                      fontSize: 10.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 22,
              child: Center(
                child: isDone
                    ? const Icon(
                        Icons.check_rounded,
                        size: 14,
                        color: AppColors.green,
                      )
                    : isCurrent
                    ? Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.maroon,
                          shape: BoxShape.circle,
                          // A ring drawn as an outward box-shadow (rather
                          // than a border, which paints inward and would
                          // swallow this 8px circle entirely) — matches
                          // the mockup's `box-shadow: 0 0 0 4px`.
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: AppColors.maroonPale,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
