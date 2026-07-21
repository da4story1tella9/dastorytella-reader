/// Library tab — grid of saved books, Saved/Collections/Archive segmented
/// switcher, and the mini-player. Mirrors the Library screen in
/// `docs/design-reference/app-mockups-v2.html`.
///
/// Uses hardcoded mock data (`state/mock_library_data.dart`) — no
/// backend calls yet.
library;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../models/book.dart';
import '../models/library_segment.dart';
import '../state/library_providers.dart';
import '../widgets/book_card.dart';
import '../widgets/library_segmented_control.dart';
import '../widgets/mini_player.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LibrarySegment segment = ref.watch(librarySegmentProvider);
    final List<Book> books = ref.watch(libraryBooksProvider);
    final Book? nowPlaying = books.isEmpty ? null : books.first;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Text(
                                'Library',
                                style: AppTypography.screenTitle,
                              ),
                              Row(
                                children: <Widget>[
                                  _IconButton(icon: Icons.search, onTap: () {}),
                                  const SizedBox(width: 8),
                                  _IconButton(
                                    icon: Icons.filter_list,
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          LibrarySegmentedControl(
                            selected: segment,
                            onChanged: (LibrarySegment value) =>
                                ref
                                    .read(librarySegmentProvider.notifier)
                                    .state = value,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                    sliver: SliverLayoutBuilder(
                      builder:
                          (BuildContext context, SliverConstraints constraints) {
                            const int crossAxisCount = 2;
                            const double crossAxisSpacing = 16;
                            const double coverAspectRatio = 3 / 4.3;
                            // Space below the cover for title + byline +
                            // progress bar (see BookCard) — a fixed aspect
                            // ratio for the whole cell can't fit both a
                            // width-scaled cover and fixed-height text, so
                            // this is computed rather than guessed.
                            const double metaBlockHeight = 58;
                            final double cellWidth =
                                (constraints.crossAxisExtent -
                                    crossAxisSpacing) /
                                crossAxisCount;
                            final double cellHeight =
                                cellWidth / coverAspectRatio + metaBlockHeight;
                            return SliverGrid(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    mainAxisSpacing: 16,
                                    crossAxisSpacing: crossAxisSpacing,
                                    mainAxisExtent: cellHeight,
                                  ),
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) =>
                                    BookCard(book: books[index]),
                                childCount: books.length,
                              ),
                            );
                          },
                    ),
                  ),
                ],
              ),
            ),
            if (nowPlaying != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: MiniPlayer(
                  book: nowPlaying,
                  subtitle: 'Ch. 3 · 14:22 left',
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.line),
        ),
        child: Icon(icon, size: 16, color: AppColors.ink),
      ),
    );
  }
}
