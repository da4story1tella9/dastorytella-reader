/// Voices tab — voice catalog with All/Cloud/Downloaded segmented
/// switcher, Explore/Recents/Favorites and category chip rows, and the
/// voice list. Mirrors the Voices screen in
/// `docs/design-reference/app-mockups-v2.html`.
///
/// Uses hardcoded mock data (`state/mock_voices_data.dart`) — no
/// backend calls yet. The chip rows track selection locally but don't
/// filter the mock list, matching the segmented control's fidelity on
/// the Library screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_typography.dart';
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
    final List<Voice> voices = ref.watch(voicesListProvider);

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
                    AppIconButton(icon: Icons.search, onTap: () {}),
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
            for (final Voice voice in voices) VoiceCard(voice: voice),
          ],
        ),
      ),
    );
  }
}
