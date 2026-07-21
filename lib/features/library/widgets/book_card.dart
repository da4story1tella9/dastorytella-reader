/// Grid cell for a single book — cover art, title, byline, progress bar.
/// Mirrors `.book-card` in `docs/design-reference/app-mockups-v2.html`.
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../models/book.dart';

class BookCard extends StatelessWidget {
  const BookCard({required this.book, super.key});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Expanded (rather than sizing the cover purely off its own
        // AspectRatio) so the grid cell's fixed height — computed in
        // LibraryScreen from an estimate of this text block's height —
        // can never overflow: any estimate error just makes the cover a
        // touch off its exact aspect ratio instead of throwing.
        Expanded(
          child: AspectRatio(
            aspectRatio: 3 / 4.3,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: book.coverGradient,
                ),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Color(0x1A251D18),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        book.spineLabel,
                        style: AppTypography.bookTitle.copyWith(
                          color: Colors.white,
                          fontSize: 11.5,
                          height: 1.25,
                        ),
                      ),
                    ),
                  ),
                  if (book.isDownloaded)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: const BoxDecoration(
                          color: Color(0xEBFFFFFF),
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          size: 13,
                          color: AppColors.green,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          book.title,
          style: AppTypography.bookTitle.copyWith(fontSize: 13.5),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 1),
        Text(
          book.byline,
          style: AppTypography.body.copyWith(
            color: AppColors.inkSoft,
            fontSize: 11,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: book.progress,
            minHeight: 3,
            backgroundColor: AppColors.line,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
          ),
        ),
      ],
    );
  }
}
