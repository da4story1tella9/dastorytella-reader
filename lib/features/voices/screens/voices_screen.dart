/// Voices tab — voice catalog with All/Cloud/Downloaded segmented
/// switcher, Explore/Recents/Favorites and category chip rows, and the
/// voice list. Mirrors the Voices screen in
/// `docs/design-reference/app-mockups-v2.html`.
///
/// The voice list is real now (`state/voices_providers.dart`,
/// ADR-0009), fetched from the backend's `/tts/voices`. The chip rows
/// still only track selection locally without filtering the list —
/// same fidelity gap as the segmented control on the Library screen,
/// unrelated to this ADR.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/tts/tts_client.dart';
import '../../../shared_widgets/app_chip.dart';
import '../../../shared_widgets/app_icon_button.dart';
import '../../../shared_widgets/app_segmented_control.dart';
import '../models/voice.dart';
import '../models/voice_category.dart';
import '../models/voice_explore_tab.dart';
import '../models/voices_segment.dart';
import '../state/voices_providers.dart';
import '../widgets/voice_card.dart';

class VoicesScreen extends ConsumerWidget {
  const VoicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final VoicesSegment segment = ref.watch(voicesSegmentProvider);
    final VoiceExploreTab exploreTab = ref.watch(voiceExploreTabProvider);
    final VoiceCategory category = ref.watch(voiceCategoryProvider);
    final AsyncValue<List<Voice>> voicesAsync = ref.watch(voicesListProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('Voices', style: AppTypography.screenTitle),
                Row(
                  children: <Widget>[
                    AppIconButton(
                      icon: Icons.search,
                      onTap: () => context.push('/search'),
                    ),
                    const SizedBox(width: 8),
                    AppIconButton(icon: Icons.filter_list, onTap: () {}),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            AppSegmentedControl<VoicesSegment>(
              options: VoicesSegment.values,
              selected: segment,
              labelBuilder: (VoicesSegment s) => s.label,
              onChanged: (VoicesSegment value) =>
                  ref.read(voicesSegmentProvider.notifier).state = value,
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 34,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(right: 20),
                itemCount: VoiceExploreTab.values.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(width: 8),
                itemBuilder: (BuildContext context, int index) {
                  final VoiceExploreTab tab = VoiceExploreTab.values[index];
                  return AppChip(
                    label: tab.label,
                    active: tab == exploreTab,
                    onTap: () =>
                        ref.read(voiceExploreTabProvider.notifier).state = tab,
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 34,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(right: 20),
                itemCount: VoiceCategory.values.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(width: 8),
                itemBuilder: (BuildContext context, int index) {
                  final VoiceCategory c = VoiceCategory.values[index];
                  return AppChip(
                    label: c.label,
                    active: c == category,
                    onTap: () =>
                        ref.read(voiceCategoryProvider.notifier).state = c,
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            voicesAsync.when(
              data: (List<Voice> voices) => Column(
                children: <Widget>[
                  for (final Voice voice in voices) VoiceCard(voice: voice),
                ],
              ),
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
              error: (Object error, StackTrace _) => _VoicesErrorState(
                message: error is TTSRequestException
                    ? error.message
                    : 'Something went wrong loading voices.',
                onRetry: () => ref.invalidate(voicesListProvider),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VoicesErrorState extends StatelessWidget {
  const _VoicesErrorState({required this.message, required this.onRetry});

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
