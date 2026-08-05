/// Book detail screen — hero summary, Chapters/Bookmarks/Details
/// tabs, chapter list. Mirrors "Book detail · Chapters" in
/// `docs/design-reference/app-mockups-core-batch1.html`.
///
/// Real now (docs/adr/0011-real-book-detail.md): fetches the actual
/// book by id (`state/book_detail_providers.dart`) and shows its real
/// chapters. Tapping a chapter starts real synthesis of that
/// chapter's real text (`NowPlayingController.playChapter`) and opens
/// the Player. "Current chapter" highlighting only applies if this
/// book is the one actually loaded in the shared now-playing state —
/// otherwise every chapter shows as plain/upcoming, since there's no
/// persisted reading progress yet to derive a "done" state from.
/// Bookmarks/Details tabs aren't designed in the reference mockups
/// yet, so they show a coming-soon placeholder.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/books/books_client.dart';
import '../../../core/books/remote_book.dart';
import '../../../core/playback/now_playing_controller.dart';
import '../../../core/playback/now_playing_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/duration_format.dart';
import '../../../shared_widgets/app_chip.dart';
import '../../../shared_widgets/app_icon_button.dart';
import '../../../shared_widgets/mini_player.dart';
import '../../library/models/book.dart' as library_book;
import '../../library/state/book_mapper.dart';
import '../models/book_detail_tab.dart';
import '../state/book_detail_providers.dart';
import '../state/book_detail_ui_providers.dart';
import '../widgets/chapter_row.dart';

class BookDetailScreen extends ConsumerWidget {
  const BookDetailScreen({required this.bookId, super.key});

  final String bookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<RemoteBook?> bookAsync = ref.watch(
      bookDetailProvider(bookId),
    );

    return bookAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (Object error, StackTrace _) => _BookDetailError(
        message: error is BooksRequestException
            ? error.message
            : 'Something went wrong loading this book.',
        onRetry: () => ref.invalidate(bookDetailProvider(bookId)),
      ),
      data: (RemoteBook? remoteBook) {
        if (remoteBook == null) {
          return const _BookDetailError(
            message: 'Book not found.',
            onRetry: null,
          );
        }
        return _BookDetailBody(book: remoteBook);
      },
    );
  }
}

class _BookDetailError extends StatelessWidget {
  const _BookDetailError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: AppIconButton(
                  icon: Icons.arrow_back,
                  onTap: () =>
                      context.canPop() ? context.pop() : context.go('/library'),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: AppTypography.body.copyWith(
                          color: AppColors.inkSoft,
                        ),
                      ),
                      if (onRetry != null) ...<Widget>[
                        const SizedBox(height: 14),
                        TextButton(
                          onPressed: onRetry,
                          child: const Text('Retry'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookDetailBody extends ConsumerWidget {
  const _BookDetailBody({required this.book});

  final RemoteBook book;

  Future<void> _playChapter(
    WidgetRef ref,
    BuildContext context,
    library_book.Book uiBook,
    RemoteChapter chapter,
  ) async {
    await ref
        .read(nowPlayingProvider.notifier)
        .playChapter(
          bookId: book.id,
          bookTitle: book.title,
          spineLabel: uiBook.spineLabel,
          coverGradient: uiBook.coverGradient,
          chapterIndex: chapter.index,
          totalChapters: book.chapters.length,
          sentences: chapter.sentences,
          isDownloaded: false,
        );
    if (context.mounted) {
      context.push('/player');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BookDetailTab tab = ref.watch(bookDetailTabProvider);
    final NowPlayingState nowPlaying = ref.watch(nowPlayingProvider);
    final library_book.Book uiBook = toUiBook(book);

    final bool isThisBookLoaded = nowPlaying.track.bookId == book.id;
    final int currentChapterIndex = isThisBookLoaded
        ? nowPlaying.track.chapterIndex
        : 0;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      AppIconButton(
                        icon: Icons.arrow_back,
                        onTap: () => context.canPop()
                            ? context.pop()
                            : context.go('/library'),
                      ),
                      AppIconButton(icon: Icons.more_horiz, onTap: () {}),
                    ],
                  ),
                  const SizedBox(height: 6),
                  _BookHero(book: uiBook),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 34,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(right: 20),
                      itemCount: BookDetailTab.values.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(width: 8),
                      itemBuilder: (BuildContext context, int index) {
                        final BookDetailTab t = BookDetailTab.values[index];
                        return AppChip(
                          label: t.label,
                          active: t == tab,
                          onTap: () =>
                              ref.read(bookDetailTabProvider.notifier).state =
                                  t,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (tab == BookDetailTab.chapters)
                    for (final RemoteChapter chapter in book.chapters)
                      ChapterRow(
                        index: chapter.index,
                        title: chapter.title,
                        subtitle: chapter.index == currentChapterIndex
                            ? '${formatMinutesSeconds(nowPlaying.remainingSeconds)} '
                                  'left of '
                                  '${formatMinutesSeconds(nowPlaying.durationSeconds)}'
                            : _sentenceCountLabel(chapter.sentences),
                        status: chapter.index == currentChapterIndex
                            ? ChapterRowStatus.current
                            : ChapterRowStatus.upcoming,
                        onTap: () =>
                            _playChapter(ref, context, uiBook, chapter),
                      )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(
                          '${tab.label} coming soon.',
                          style: AppTypography.body.copyWith(
                            color: AppColors.inkSoft,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (nowPlaying.track.bookId.isNotEmpty)
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

String _sentenceCountLabel(List<String> sentences) =>
    sentences.length == 1 ? '1 sentence' : '${sentences.length} sentences';

class _BookHero extends StatelessWidget {
  const _BookHero({required this.book});

  final library_book.Book book;

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
              colors: book.coverGradient,
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
              Text(
                book.title,
                style: AppTypography.bookTitle.copyWith(fontSize: 16.5),
              ),
              const SizedBox(height: 2),
              Text(
                book.byline,
                style: AppTypography.body.copyWith(
                  color: AppColors.inkSoft,
                  fontSize: 11.5,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Tap a chapter to start listening',
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
