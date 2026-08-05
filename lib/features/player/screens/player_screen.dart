/// Now-playing screen — chapter transcript, waveform, transport
/// controls, and playback function chips. Mirrors the "Player —
/// functional detail" screen in
/// `docs/design-reference/app-mockups-v2.html`.
///
/// Reads/mutates the shared now-playing state (`core/playback/`) so
/// it always agrees with the Library mini-player. Real audio, real
/// content — a real chapter, chosen from Book Detail
/// (ADR-0011/`NowPlayingController.playChapter`). Reachable only via
/// the mini-player or a chapter tap, both of which only exist once
/// something real is already selected, but the empty-track guard
/// below still exists for a direct/stale navigation. The cover's
/// subtle "breathing" scale animation from the mockup is skipped as a
/// decorative flourish not needed for functional fidelity.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/playback/now_playing_controller.dart';
import '../../../core/playback/now_playing_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/duration_format.dart';
import '../../../shared_widgets/app_icon_button.dart';
import '../../../shared_widgets/app_segmented_control.dart';
import '../models/player_tab.dart';
import '../state/player_ui_providers.dart';
import '../widgets/function_chip.dart';
import '../widgets/player_controls.dart';
import '../widgets/transcript_card.dart';
import '../widgets/waveform_bars.dart';

class PlayerScreen extends ConsumerWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final NowPlayingState nowPlaying = ref.watch(nowPlayingProvider);
    final NowPlayingController controller = ref.read(
      nowPlayingProvider.notifier,
    );
    final PlayerTab tab = ref.watch(playerTabProvider);
    final double playedFraction = nowPlaying.durationSeconds == 0
        ? 0
        : nowPlaying.positionSeconds / nowPlaying.durationSeconds;

    // Defensive only — reachable via the mini-player or a chapter
    // tap, both of which only appear once something real is already
    // selected (see this file's doc comment), but a direct/stale
    // navigation shouldn't render the rest of this screen against an
    // empty track (e.g. "Chapter 0 of 0").
    if (nowPlaying.track.bookId.isEmpty) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: AppIconButton(
                  icon: Icons.keyboard_arrow_down,
                  onTap: () => context.canPop()
                      ? context.pop()
                      : context.go('/library'),
                ),
              ),
              const Expanded(
                child: Center(child: Text('Nothing is playing.')),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                AppIconButton(
                  icon: Icons.keyboard_arrow_down,
                  onTap: () =>
                      context.canPop() ? context.pop() : context.go('/library'),
                ),
                GestureDetector(
                  onTap: () =>
                      context.push('/book/${nowPlaying.track.bookId}'),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Chapter ${nowPlaying.track.chapterIndex}',
                            style: AppTypography.bodyStrong.copyWith(
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(width: 3),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            size: 14,
                            color: AppColors.ink,
                          ),
                        ],
                      ),
                      const SizedBox(height: 1),
                      Text(
                        'of ${nowPlaying.track.totalChapters} · '
                        '${nowPlaying.track.bookTitle}',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.inkFaint,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                AppIconButton(icon: Icons.more_horiz, onTap: () {}),
              ],
            ),
            const SizedBox(height: 14),
            Center(
              child: SizedBox(
                width: 180,
                child: AppSegmentedControl<PlayerTab>(
                  options: PlayerTab.values,
                  selected: tab,
                  labelBuilder: (PlayerTab t) => t.label,
                  onChanged: (PlayerTab value) =>
                      ref.read(playerTabProvider.notifier).state = value,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: 150,
                height: 212,
                padding: const EdgeInsets.all(16),
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: nowPlaying.track.coverGradient,
                  ),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Color(0x1A251D18),
                      blurRadius: 34,
                      offset: Offset(0, 20),
                    ),
                  ],
                ),
                child: Text(
                  nowPlaying.track.spineLabel,
                  textAlign: TextAlign.center,
                  style: AppTypography.bookTitle.copyWith(
                    color: Colors.white,
                    fontSize: 12.5,
                    height: 1.3,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Center(
              child: Text(
                nowPlaying.track.bookTitle,
                style: AppTypography.bookTitle.copyWith(fontSize: 19),
              ),
            ),
            const SizedBox(height: 6),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.line),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(
                      Icons.record_voice_over_outlined,
                      size: 12,
                      color: AppColors.inkSoft,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      nowPlaying.track.voiceLabel,
                      style: AppTypography.bodyStrong.copyWith(
                        fontSize: 11.5,
                        color: AppColors.inkSoft,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.chevron_right,
                      size: 13,
                      color: AppColors.inkSoft,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TranscriptCard(
              sentences: nowPlaying.track.transcript,
              onViewFullTap: () {},
            ),
            const SizedBox(height: 16),
            if (nowPlaying.isLoadingAudio)
              const _AudioStatusBanner.loading()
            else if (nowPlaying.loadErrorMessage != null)
              _AudioStatusBanner.error(
                message: nowPlaying.loadErrorMessage!,
                onRetry: controller.retryLoadAudio,
              ),
            if (nowPlaying.isLoadingAudio || nowPlaying.loadErrorMessage != null)
              const SizedBox(height: 16),
            WaveformBars(playedFraction: playedFraction),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  formatMinutesSeconds(nowPlaying.positionSeconds),
                  style: AppTypography.caption.copyWith(
                    color: AppColors.inkFaint,
                    fontSize: 10.5,
                  ),
                ),
                Text(
                  formatMinutesSeconds(nowPlaying.durationSeconds),
                  style: AppTypography.caption.copyWith(
                    color: AppColors.inkFaint,
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            PlayerControls(
              isPlaying: nowPlaying.isPlaying,
              onSkipBack: () => controller.skip(-15),
              onTogglePlaying: controller.togglePlaying,
              onSkipForward: () => controller.skip(15),
            ),
            const SizedBox(height: 20),
            // Centered when the chips fit the available width (desktop/
            // wide viewports), scrollable and left-starting when they
            // don't (narrow phone frames) — a plain horizontal ListView
            // always left-aligns, which looked off-center under the
            // already-centered transport controls above on wide screens.
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SizedBox(
                  height: 38,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(width: 20),
                          FunctionChip(
                            label: '${nowPlaying.speed}× Speed',
                            onTap: controller.cycleSpeed,
                          ),
                          const SizedBox(width: 8),
                          FunctionChip(
                            icon: Icons.download_done,
                            label: 'Downloaded',
                            active: nowPlaying.track.isDownloaded,
                            onTap: () {},
                          ),
                          const SizedBox(width: 8),
                          FunctionChip(
                            icon: Icons.timer_outlined,
                            label: 'Sleep: ${nowPlaying.sleepTimerLabel}',
                            onTap: controller.cycleSleepTimer,
                          ),
                          const SizedBox(width: 8),
                          FunctionChip(
                            icon: nowPlaying.isBookmarked
                                ? Icons.star
                                : Icons.star_border,
                            label: 'Bookmark',
                            active: nowPlaying.isBookmarked,
                            onTap: controller.toggleBookmark,
                          ),
                          const SizedBox(width: 8),
                          FunctionChip(
                            icon: Icons.ios_share,
                            label: 'Share',
                            onTap: () {},
                          ),
                          const SizedBox(width: 20),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Shown in place of the waveform's played-fraction fill while this
/// chapter's narration is still loading, or if it failed to — see
/// `NowPlayingState.isLoadingAudio`/`loadErrorMessage`.
class _AudioStatusBanner extends StatelessWidget {
  const _AudioStatusBanner.loading() : message = null, onRetry = null;

  const _AudioStatusBanner.error({
    required String this.message,
    required VoidCallback this.onRetry,
  });

  /// Null means the loading variant; non-null means the error variant
  /// with this text.
  final String? message;
  final VoidCallback? onRetry;

  bool get _isLoading => message == null;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _isLoading ? AppColors.surfaceAlt : AppColors.errorPale,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: <Widget>[
          if (_isLoading)
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            const Icon(Icons.error_outline, size: 16, color: AppColors.error),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _isLoading ? 'Loading narration…' : message!,
              style: AppTypography.body.copyWith(
                color: _isLoading ? AppColors.inkSoft : AppColors.error,
                fontSize: 12,
              ),
            ),
          ),
          if (onRetry != null)
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
