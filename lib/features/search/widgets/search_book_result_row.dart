/// Row for a matching book. Mirrors `.result-row` in
/// `docs/design-reference/app-mockups-core-batch2.html`.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../library/models/book.dart';
import 'highlighted_text.dart';

class SearchBookResultRow extends StatelessWidget {
  const SearchBookResultRow({
    required this.book,
    required this.query,
    super.key,
  });

  final Book book;
  final String query;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Search's results are still mock data (out of ADR-0011's
      // scope), so this real book id won't resolve to anything —
      // Book Detail correctly shows "not found" rather than the
      // route breaking outright now that it requires an id.
      onTap: () => context.push('/book/${book.id}'),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.line)),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 38,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: book.coverGradient,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  HighlightedText(
                    text: book.title,
                    query: query,
                    style: AppTypography.bodyStrong.copyWith(fontSize: 13),
                    highlightColor: AppColors.maroon,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    '${book.byline} · ${(book.progress * 100).round()}% '
                    'complete',
                    style: AppTypography.body.copyWith(
                      color: AppColors.inkSoft,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
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
