/// Library tab — grid of saved books, Saved/Collections/Archive segmented
/// switcher, and the mini-player. Mirrors the Library screen in
/// `docs/design-reference/app-mockups-v2.html`.
///
/// The Saved segment is real now (`state/library_providers.dart`,
/// ADR-0010) — fetched from the backend, with a real "import a book"
/// flow (pick an EPUB, parse it, save it) behind the "+" icon and the
/// empty-state CTA. Collections/Archive stay empty — no backend
/// concept for either exists yet, same gap as before this ADR.
library;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/books/books_client.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared_widgets/app_icon_button.dart';
import '../../../shared_widgets/app_segmented_control.dart';
import '../../../shared_widgets/mini_player.dart';
import '../models/book.dart';
import '../models/library_segment.dart';
import '../state/import_controller.dart';
import '../state/import_state.dart';
import '../state/library_providers.dart';
import '../widgets/book_card.dart';
import '../widgets/empty_library_state.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  Future<void> _handleImport(BuildContext context, WidgetRef ref) async {
    final bool success = await ref
        .read(importControllerProvider.notifier)
        .pickAndImportBook();
    if (!context.mounted) {
      return;
    }
    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Book imported.')));
      return;
    }
    final String? errorMessage = ref.read(importControllerProvider).errorMessage;
    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
    // Neither branch: the user just cancelled the file picker —
    // nothing went wrong, nothing to show.
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LibrarySegment segment = ref.watch(librarySegmentProvider);
    final AsyncValue<List<Book>> booksAsync = ref.watch(libraryBooksProvider);
    final bool isImporting = ref.watch(
      importControllerProvider.select((ImportState s) => s.isImporting),
    );

    final bool isSaved = segment == LibrarySegment.saved;
    final List<Book> books = isSaved
        ? (booksAsync.valueOrNull ?? const <Book>[])
        : const <Book>[];
    final bool isLoadingBooks = isSaved && booksAsync.isLoading;
    final Object? booksError = isSaved ? booksAsync.error : null;

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
                                  if (isImporting)
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6,
                                      ),
                                      child: SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    )
                                  else
                                    AppIconButton(
                                      icon: Icons.add,
                                      onTap: () => _handleImport(context, ref),
                                    ),
                                  const SizedBox(width: 8),
                                  AppIconButton(
                                    icon: Icons.search,
                                    onTap: () => context.push('/search'),
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
                            onChanged: (LibrarySegment value) => ref
                                .read(librarySegmentProvider.notifier)
                                .state = value,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isLoadingBooks)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 60),
                        child: Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
                    )
                  else if (booksError != null)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                        child: _LibraryErrorState(
                          message: booksError is BooksRequestException
                              ? booksError.message
                              : 'Something went wrong loading your library.',
                          onRetry: () => ref.invalidate(libraryBooksProvider),
                        ),
                      ),
                    )
                  else if (books.isEmpty)
                    SliverToBoxAdapter(
                      child: EmptyLibraryState(
                        title: isSaved
                            ? 'Your library is empty'
                            : 'No ${segment.label.toLowerCase()} yet',
                        body: isSaved
                            ? 'Add a book, article, or draft to hear it '
                                'read back to you — in whichever voice '
                                'fits the mood.'
                            : 'Books you add to ${segment.label.toLowerCase()} '
                                'will show up here.',
                        showImportCta: isSaved,
                        onImportTap: isSaved
                            ? () => _handleImport(context, ref)
                            : null,
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                      sliver: SliverLayoutBuilder(
                        builder: (
                          BuildContext context,
                          SliverConstraints constraints,
                        ) {
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
                              (constraints.crossAxisExtent - crossAxisSpacing) /
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
            if (books.isNotEmpty)
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

class _LibraryErrorState extends StatelessWidget {
  const _LibraryErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.errorPale,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: <Widget>[
          const Icon(Icons.error_outline, size: 16, color: AppColors.error),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: AppTypography.body.copyWith(
                color: AppColors.error,
                fontSize: 12,
              ),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: Text(
              'Retry',
              style: AppTypography.bodyStrong.copyWith(
                color: AppColors.maroon,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
