/// Compact "currently playing" bar pinned above the bottom nav.
/// Mirrors `.mini-player` in `docs/design-reference/app-mockups-v2.html`.
///
/// Reads the shared now-playing state (`core/playback/`) so it always
/// agrees with the full Player screen. Tapping the row opens the
/// Player; tapping the play/pause button toggles playback in place.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/playback/now_playing_controller.dart';
import '../../../core/playback/now_playing_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/duration_format.dart';

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final NowPlayingState nowPlaying = ref.watch(nowPlayingProvider);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => context.push('/player'),
      child: Container(
        margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.line),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x1A251D18),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: nowPlaying.track.coverGradient,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    nowPlaying.track.bookTitle,
                    style: AppTypography.bodyStrong.copyWith(fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Ch. ${nowPlaying.track.chapterIndex} · '
                    '${formatMinutesSeconds(nowPlaying.remainingSeconds)} left',
                    style: AppTypography.body.copyWith(
                      color: AppColors.inkSoft,
                      fontSize: 10.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () =>
                  ref.read(nowPlayingProvider.notifier).togglePlaying(),
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: AppColors.ink,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  nowPlaying.isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
