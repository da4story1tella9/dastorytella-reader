/// Settings tab — profile card, Reading & Playback / Storage / Account
/// setting groups. Mirrors the Settings screen in
/// `docs/design-reference/app-mockups-core-batch1.html`.
///
/// Uses hardcoded mock data (`state/mock_settings_data.dart`) — no
/// backend calls yet; every row is a `() {}` tap stub.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_typography.dart';
import '../../pronunciation_dictionary/state/pronunciation_providers.dart';
import '../models/settings_group.dart';
import '../models/settings_item.dart';
import '../state/mock_settings_data.dart';
import '../widgets/profile_card.dart';
import '../widgets/settings_group_card.dart';
import '../widgets/settings_row.dart';
import '../widgets/storage_row.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SettingsGroup readingAndPlayback = mockSettingsGroups[0];
    final SettingsGroup account = mockSettingsGroups[1];
    final int pronunciationEntryCount = ref
        .watch(
          pronunciationEntriesProvider,
        )
        .length;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
          children: <Widget>[
            const Text('Settings', style: AppTypography.screenTitle),
            const SizedBox(height: 18),
            const ProfileCard(profile: mockUserProfile),
            const SizedBox(height: 22),
            SettingsGroupCard(
              label: readingAndPlayback.label,
              children: <Widget>[
                for (final SettingsItem item in readingAndPlayback.items)
                  SettingsRow(
                    item: item.title == 'Pronunciation dictionary'
                        ? SettingsItem(
                            icon: item.icon,
                            title: item.title,
                            subtitle: '$pronunciationEntryCount custom '
                                '${pronunciationEntryCount == 1 ? 'entry' : 'entries'}',
                          )
                        : item,
                    onTap: item.title == 'Pronunciation dictionary'
                        ? () => context.push('/pronunciations')
                        : () {},
                  ),
              ],
            ),
            const SizedBox(height: 22),
            SettingsGroupCard(
              label: 'Storage',
              children: <Widget>[
                StorageRow(
                  stats: mockStorageStats,
                  onManageTap: () => context.push('/downloads'),
                ),
              ],
            ),
            const SizedBox(height: 22),
            SettingsGroupCard(
              label: account.label,
              children: <Widget>[
                for (final SettingsItem item in account.items)
                  SettingsRow(
                    item: item,
                    onTap: item.title == 'Log out'
                        ? () => context.go('/onboarding')
                        : () {},
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
