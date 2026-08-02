import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Renders [text] with every case-insensitive occurrence of [query]
/// visually emphasized. Mirrors `<mark>` in
/// `docs/design-reference/app-mockups-core-batch2.html`.
class HighlightedText extends StatelessWidget {
  const HighlightedText({
    required this.text,
    required this.query,
    required this.style,
    this.highlightColor = AppColors.ink,
    this.maxLines,
    this.overflow,
    super.key,
  });

  final String text;
  final String query;
  final TextStyle style;
  final Color highlightColor;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
      text: TextSpan(style: style, children: _spans()),
    );
  }

  List<InlineSpan> _spans() {
    if (query.isEmpty) {
      return <InlineSpan>[TextSpan(text: text)];
    }
    final String lowerText = text.toLowerCase();
    final String lowerQuery = query.toLowerCase();
    final List<InlineSpan> spans = <InlineSpan>[];
    int start = 0;
    while (true) {
      final int matchIndex = lowerText.indexOf(lowerQuery, start);
      if (matchIndex == -1) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }
      if (matchIndex > start) {
        spans.add(TextSpan(text: text.substring(start, matchIndex)));
      }
      spans.add(
        TextSpan(
          text: text.substring(matchIndex, matchIndex + query.length),
          style: TextStyle(
            backgroundColor: AppColors.goldPale,
            color: highlightColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
      start = matchIndex + query.length;
    }
    return spans;
  }
}
