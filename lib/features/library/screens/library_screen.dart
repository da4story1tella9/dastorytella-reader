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

import '../../../core/theme/app_typography.dart';
import '../../../shared_widgets/app_icon_button.dart';
import '../../../shared_widgets/app_segmented_control.dart';
import '../../../shared_widgets/mini_player.dart';
import '../models/book.dart';
import '../models/library_segment.dart';
import '../state/library_providers.dart';
import '../widgets/book_card.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LibrarySegment segment = ref.watch(librarySegmentProvider);
    final List<Book> books = ref.watch(libraryBooksProvider);

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
                                  AppIconButton(
                                    icon: Icons.search,
                                    onTap: () {},
                                  ),
                                  const SizedBox(width: 8),
                                  AppIconButton(
                                    icon: Icons.filter_list,
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          AppSegmentedControl<LibrarySegment>(
                            options: LibrarySegment.values,
                            selected: segment,
                            labelBuilder: (LibrarySegment s) => s.label,
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
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: MiniPlayer(),
            ),
          ],
        ),
      ),
    );
  }
}
