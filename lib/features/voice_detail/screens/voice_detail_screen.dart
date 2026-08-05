/// Voice detail / preview screen — hero, sample previews, and
/// book-assignment list. Mirrors
/// `docs/design-reference/app-mockups-secondary-batch.html`.
///
/// The voice itself is real now (`voicesListProvider`, ADR-0009),
/// including a real "Play preview" using ElevenLabs' own preview
/// audio, and "Set as default" writes to the shared
/// `selectedVoiceIdProvider` that `NowPlayingController` reads —
/// picking a voice here actually changes what narrates future
/// playback. Favorite/book-assignment toggles stay local-only mock
/// state (unrelated to ElevenLabs data, out of this ADR's scope), and
/// the "HEAR HOW IT HANDLES…" sample cards stay visual-only too —
/// real per-sample synthesis is a reasonable follow-up, not done here
/// to keep this slice shipped (see ADR-0009's Alternatives).
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/tts/selected_voice.dart';
import '../../../core/tts/tts_client.dart';
import '../../../shared_widgets/app_icon_button.dart';
import '../../library/models/book.dart';
import '../../library/state/mock_library_data.dart';
import '../../voices/models/voice.dart';
import '../../voices/state/voices_providers.dart';
import '../models/voice_sample.dart';
import '../state/mock_voice_samples.dart';
import '../widgets/mini_waveform.dart';

class VoiceDetailScreen extends ConsumerStatefulWidget {
  const VoiceDetailScreen({required this.voiceId, super.key});

  final String voiceId;

  @override
  ConsumerState<VoiceDetailScreen> createState() => _VoiceDetailScreenState();
}

class _VoiceDetailScreenState extends ConsumerState<VoiceDetailScreen> {
  bool _isFavorite = false;
  final Set<int> _playingSamples = <int>{};
  Set<String>? _assignedBookIds;

  late final AudioPlayer _previewPlayer;
  bool _isPreviewPlaying = false;
  bool _isPreviewLoading = false;
  String? _loadedPreviewUrl;

  @override
  void initState() {
    super.initState();
    _previewPlayer = AudioPlayer();
    _previewPlayer.playerStateStream.listen((PlayerState state) {
      if (!mounted) return;
      setState(() => _isPreviewPlaying = state.playing);
      if (state.processingState == ProcessingState.completed) {
        unawaited(_previewPlayer.pause());
        unawaited(_previewPlayer.seek(Duration.zero));
      }
    });
  }

  @override
  void dispose() {
    unawaited(_previewPlayer.dispose());
    super.dispose();
  }

  void _ensureAssignedBookIds(Voice voice) {
    // A book's byline is "{Narrator} · {Style}" — treat a byline
    // match on this voice's name as "currently assigned" (see Book
    // model). Computed once per resolved voice, not every rebuild.
    _assignedBookIds ??= mockBooks
        .where((Book b) => b.byline.split(' · ').first == voice.name)
        .map((Book b) => b.id)
        .toSet();
  }

  Future<void> _togglePreview(String? previewUrl) async {
    if (previewUrl == null) {
      return;
    }
    if (_isPreviewPlaying) {
      await _previewPlayer.pause();
      return;
    }
    setState(() => _isPreviewLoading = true);
    try {
      if (_loadedPreviewUrl != previewUrl) {
        await _previewPlayer.setUrl(previewUrl);
        _loadedPreviewUrl = previewUrl;
      }
      await _previewPlayer.play();
    } catch (_) {
      // A preview failing to load isn't worth a scary error banner
      // for what's a nice-to-have, unlike the main Player's narration
      // load failure — just leave it not-playing.
    } finally {
      if (mounted) {
        setState(() => _isPreviewLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Voice>> voicesAsync = ref.watch(voicesListProvider);

    return voicesAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (Object error, StackTrace _) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              error is TTSRequestException
                  ? error.message
                  : 'Something went wrong loading this voice.',
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(color: AppColors.inkSoft),
            ),
          ),
        ),
      ),
      data: (List<Voice> voices) {
        Voice? voice;
        for (final Voice v in voices) {
          if (v.id == widget.voiceId) {
            voice = v;
            break;
          }
        }
        if (voice == null) {
          return const Scaffold(
            body: Center(child: Text('Voice not found.')),
          );
        }
        _ensureAssignedBookIds(voice);
        return _VoiceDetailBody(
          voice: voice,
          isFavorite: _isFavorite,
          onToggleFavorite: () => setState(() => _isFavorite = !_isFavorite),
          isPreviewPlaying: _isPreviewPlaying,
          isPreviewLoading: _isPreviewLoading,
          onTogglePreview: () => _togglePreview(voice!.previewUrl),
          playingSamples: _playingSamples,
          onToggleSample: (int i) => setState(() {
            if (!_playingSamples.add(i)) {
              _playingSamples.remove(i);
            }
          }),
          assignedBookIds: _assignedBookIds!,
          onToggleBook: (String bookId) => setState(() {
            if (!_assignedBookIds!.add(bookId)) {
              _assignedBookIds!.remove(bookId);
            }
          }),
        );
      },
    );
  }
}

class _VoiceDetailBody extends ConsumerWidget {
  const _VoiceDetailBody({
    required this.voice,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.isPreviewPlaying,
    required this.isPreviewLoading,
    required this.onTogglePreview,
    required this.playingSamples,
    required this.onToggleSample,
    required this.assignedBookIds,
    required this.onToggleBook,
  });

  final Voice voice;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final bool isPreviewPlaying;
  final bool isPreviewLoading;
  final VoidCallback onTogglePreview;
  final Set<int> playingSamples;
  final void Function(int index) onToggleSample;
  final Set<String> assignedBookIds;
  final void Function(String bookId) onToggleBook;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String category = voice.tags.split(' · ').last;
    final bool isDefault = ref.watch(selectedVoiceIdProvider) == voice.id;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                AppIconButton(
                  icon: Icons.close,
                  onTap: () =>
                      context.canPop() ? context.pop() : context.go('/voices'),
                ),
                AppIconButton(
                  icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                  onTap: onToggleFavorite,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Column(
              children: <Widget>[
                InkWell(
                  onTap: voice.previewUrl == null ? null : onTogglePreview,
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: 84,
                    height: 84,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: voice.avatarGradient,
                      ),
                    ),
                    child: isPreviewLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : voice.previewUrl == null
                        ? Text(
                            voice.avatarInitial,
                            style: AppTypography.bookTitle.copyWith(
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          )
                        : Icon(
                            isPreviewPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  voice.name,
                  style: AppTypography.bookTitle.copyWith(fontSize: 21),
                ),
                const SizedBox(height: 5),
                Text(
                  voice.description,
                  textAlign: TextAlign.center,
                  style: AppTypography.body.copyWith(
                    color: AppColors.inkSoft,
                    fontSize: 12,
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 6,
                  runSpacing: 6,
                  children: <Widget>[
                    _VoiceTag(label: category),
                    if (voice.isOfflineReady)
                      const _VoiceTag(label: 'Offline ready'),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _VoiceActionButton(
                        icon: isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        label: isFavorite ? 'Favorited' : 'Favorite',
                        primary: false,
                        onTap: onToggleFavorite,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _VoiceActionButton(
                        icon: isDefault
                            ? Icons.check_rounded
                            : Icons.vertical_align_bottom,
                        label: isDefault ? 'Default voice' : 'Set as default',
                        primary: true,
                        onTap: () => ref
                            .read(selectedVoiceIdProvider.notifier)
                            .state = voice.id,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 2, bottom: 8),
              child: Text(
                'HEAR HOW IT HANDLES…',
                style: AppTypography.eyebrow.copyWith(
                  color: AppColors.inkFaint,
                ),
              ),
            ),
            for (int i = 0; i < mockVoiceSamples.length; i++) ...<Widget>[
              _SampleCard(
                sample: mockVoiceSamples[i],
                playing: playingSamples.contains(i),
                onTap: () => onToggleSample(i),
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 2, bottom: 4),
              child: Text(
                'ASSIGN TO A BOOK',
                style: AppTypography.eyebrow.copyWith(
                  color: AppColors.inkFaint,
                ),
              ),
            ),
            for (final Book book in mockBooks)
              _AssignBookRow(
                book: book,
                assigned: assignedBookIds.contains(book.id),
                onTap: () => onToggleBook(book.id),
              ),
          ],
        ),
      ),
    );
  }
}

class _VoiceTag extends StatelessWidget {
  const _VoiceTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.maroonPale,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: AppColors.maroon,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _VoiceActionButton extends StatelessWidget {
  const _VoiceActionButton({
    required this.icon,
    required this.label,
    required this.primary,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool primary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: primary ? AppColors.maroon : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: primary ? null : Border.all(color: AppColors.line),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 14,
              color: primary ? Colors.white : AppColors.ink,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTypography.bodyStrong.copyWith(
                fontSize: 12,
                color: primary ? Colors.white : AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SampleCard extends StatelessWidget {
  const _SampleCard({
    required this.sample,
    required this.playing,
    required this.onTap,
  });

  final VoiceSample sample;
  final bool playing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sample.label,
            style: AppTypography.bodyStrong.copyWith(fontSize: 11.5),
          ),
          const SizedBox(height: 4),
          Text(
            sample.text,
            style: AppTypography.transcriptBody.copyWith(
              color: AppColors.inkSoft,
              fontSize: 12.5,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              InkWell(
                onTap: onTap,
                customBorder: const CircleBorder(),
                child: Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.ink,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    playing ? Icons.pause : Icons.play_arrow_rounded,
                    size: 15,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: MiniWaveform(played: playing)),
            ],
          ),
        ],
      ),
    );
  }
}

class _AssignBookRow extends StatelessWidget {
  const _AssignBookRow({
    required this.book,
    required this.assigned,
    required this.onTap,
  });

  final Book book;
  final bool assigned;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.line)),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 32,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: book.coverGradient,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                book.title,
                style: AppTypography.bodyStrong.copyWith(fontSize: 12.5),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: assigned ? AppColors.maroon : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: assigned ? AppColors.maroon : AppColors.line,
                  width: 1.5,
                ),
              ),
              child: assigned
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
