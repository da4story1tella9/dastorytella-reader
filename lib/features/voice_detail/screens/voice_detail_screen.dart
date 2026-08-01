/// Voice detail / preview screen — hero, sample previews, and
/// book-assignment list. Mirrors
/// `docs/design-reference/app-mockups-secondary-batch.html`.
///
/// Uses hardcoded mock data — no backend calls yet. Favorite/default/
/// assignment toggles are local to this screen instance (not synced
/// elsewhere, e.g. to Settings' "Default voice" row) — consistent with
/// the fidelity level of the chip rows on Library/Voices, which also
/// track selection without wiring real filtering.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared_widgets/app_icon_button.dart';
import '../../library/models/book.dart';
import '../../library/state/mock_library_data.dart';
import '../../voices/models/voice.dart';
import '../../voices/state/mock_voices_data.dart';
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
  bool _isDefault = false;
  final Set<int> _playingSamples = <int>{};
  late Set<String> _assignedBookIds;

  Voice get _voice =>
      mockVoices.firstWhere((Voice v) => v.id == widget.voiceId);

  @override
  void initState() {
    super.initState();
    // A book's byline is "{Narrator} · {Style}" — treat a byline match
    // on this voice's name as "currently assigned" (see Book model).
    _assignedBookIds = mockBooks
        .where((Book b) => b.byline.split(' · ').first == _voice.name)
        .map((Book b) => b.id)
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    final Voice voice = _voice;
    final String category = voice.tags.split(' · ').last;

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
                  icon: _isFavorite ? Icons.favorite : Icons.favorite_border,
                  onTap: () => setState(() => _isFavorite = !_isFavorite),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Column(
              children: <Widget>[
                Container(
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
                  child: Text(
                    voice.avatarInitial,
                    style: AppTypography.bookTitle.copyWith(
                      color: Colors.white,
                      fontSize: 30,
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
                        icon: _isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        label: _isFavorite ? 'Favorited' : 'Favorite',
                        primary: false,
                        onTap: () => setState(() => _isFavorite = !_isFavorite),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _VoiceActionButton(
                        icon: _isDefault
                            ? Icons.check_rounded
                            : Icons.vertical_align_bottom,
                        label: _isDefault ? 'Default voice' : 'Set as default',
                        primary: true,
                        onTap: () => setState(() => _isDefault = !_isDefault),
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
                playing: _playingSamples.contains(i),
                onTap: () => setState(() {
                  if (!_playingSamples.add(i)) {
                    _playingSamples.remove(i);
                  }
                }),
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
                assigned: _assignedBookIds.contains(book.id),
                onTap: () => setState(() {
                  if (!_assignedBookIds.add(book.id)) {
                    _assignedBookIds.remove(book.id);
                  }
                }),
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
