/// Book detail screen — hero summary, Chapters/Bookmarks/Details
/// tabs, chapter list. Mirrors "Book detail · Chapters" in
/// `docs/design-reference/app-mockups-core-batch1.html`.
///
/// Chapter statuses (done/current/upcoming) and the current chapter's
/// subtitle are derived live from the shared now-playing state
/// (`core/playback/`), not stored as mock data — see
/// `state/mock_book_detail_data.dart`. Bookmarks/Details tabs aren't
/// designed in the reference mockups yet, so they show a coming-soon
/// placeholder rather than silently reusing the chapter list.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/playback/now_playing_controller.dart';
import '../../../core/playback/now_playing_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/duration_format.dart';
import '../../../shared_widgets/app_chip.dart';
import '../../../shared_widgets/app_icon_button.dart';
import '../../../shared_widgets/mini_player.dart';
import '../models/book_detail_tab.dart';
import '../models/chapter_summary.dart';
import '../state/book_detail_ui_providers.dart';
import '../state/mock_book_detail_data.dart';
import '../widgets/book_hero_row.dart';
import '../widgets/chapter_row.dart';

class BookDetailScreen extends ConsumerWidget {
  const BookDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BookDetailTab tab = ref.watch(bookDetailTabProvider);
    final NowPlayingState nowPlaying = ref.watch(nowPlayingProvider);
    final int currentChapterIndex = nowPlaying.track.chapterIndex;

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
                  BookHeroRow(
                    title: mockBookTitle,
                    byline: mockBookByline,
                    coverGradient: mockBookCoverGradient,
                    overallProgressPercent: mockBookOverallProgressPercent,
                    currentChapterIndex: currentChapterIndex,
                    totalChapters: mockBookTotalChapters,
                  ),
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
                    for (final ChapterSummary chapter in mockChapters)
                      ChapterRow(
                        index: chapter.index,
                        title: chapter.title,
                        subtitle: chapter.index == currentChapterIndex
                            ? '${formatMinutesSeconds(nowPlaying.remainingSeconds)} '
                                  'left of '
                                  '${formatMinutesSeconds(nowPlaying.track.durationSeconds)}'
                            : chapter.durationLabel,
                        status: chapter.index < currentChapterIndex
                            ? ChapterRowStatus.done
                            : chapter.index == currentChapterIndex
                            ? ChapterRowStatus.current
                            : ChapterRowStatus.upcoming,
                        onTap: () {},
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
