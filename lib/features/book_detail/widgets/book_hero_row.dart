/// Cover + title + byline + progress summary at the top of Book
/// Detail. Mirrors `.book-hero-row` in
/// `docs/design-reference/app-mockups-core-batch1.html`.
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class BookHeroRow extends StatelessWidget {
  const BookHeroRow({
    required this.title,
    required this.byline,
    required this.coverGradient,
    required this.overallProgressPercent,
    required this.currentChapterIndex,
    required this.totalChapters,
    super.key,
  });

  final String title;
  final String byline;
  final List<Color> coverGradient;
  final int overallProgressPercent;
  final int currentChapterIndex;
  final int totalChapters;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 64,
          height: 92,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: coverGradient,
            ),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x1A251D18),
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(title, style: AppTypography.bookTitle.copyWith(fontSize: 16.5)),
              const SizedBox(height: 2),
              Text(
                byline,
                style: AppTypography.body.copyWith(
                  color: AppColors.inkSoft,
                  fontSize: 11.5,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '$overallProgressPercent% complete · '
                'Ch. $currentChapterIndex of $totalChapters',
                style: AppTypography.bodyStrong.copyWith(
                  color: AppColors.gold,
                  fontSize: 10.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
