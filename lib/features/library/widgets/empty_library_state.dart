/// Empty-state placeholder for the Library grid. Mirrors `.empty-wrap`
/// in `docs/design-reference/app-mockups-core-batch1.html`.
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class EmptyLibraryState extends StatelessWidget {
  const EmptyLibraryState({
    required this.title,
    required this.body,
    this.showImportCta = false,
    super.key,
  });

  final String title;
  final String body;
  final bool showImportCta;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 76,
            height: 76,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(
              Icons.menu_book_outlined,
              size: 30,
              color: AppColors.maroon,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.bookTitle.copyWith(fontSize: 19),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            textAlign: TextAlign.center,
            style: AppTypography.body.copyWith(
              color: AppColors.inkSoft,
              fontSize: 12.5,
              height: 1.5,
            ),
          ),
          if (showImportCta) ...<Widget>[
            const SizedBox(height: 22),
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.maroon,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(Icons.add, size: 14, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      'Import your first book',
                      style: AppTypography.bodyStrong.copyWith(
                        color: Colors.white,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Supports EPUB, PDF, DOCX, TXT — or paste text directly',
              textAlign: TextAlign.center,
              style: AppTypography.caption.copyWith(
                color: AppColors.inkFaint,
                fontSize: 10.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
