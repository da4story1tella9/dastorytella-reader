/// Row for a matching chapter excerpt. Mirrors `.snippet-row` in
/// `docs/design-reference/app-mockups-core-batch2.html`.
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../models/chapter_snippet.dart';
import 'highlighted_text.dart';

class SearchSnippetRow extends StatelessWidget {
  const SearchSnippetRow({
    required this.snippet,
    required this.query,
    super.key,
  });

  final ChapterSnippet snippet;
  final String query;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '${snippet.bookTitle} · ${snippet.chapterLabel}',
            style: AppTypography.bodyStrong.copyWith(
              color: AppColors.maroon,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 4),
          HighlightedText(
            text: snippet.text,
            query: query,
            style: AppTypography.transcriptBody.copyWith(
              color: AppColors.inkSoft,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
