/// Hardcoded sample settings content, mirroring
/// `docs/design-reference/app-mockups-core-batch1.html`.
///
/// Placeholder until auth/settings persistence (ARCHITECTURE.md §1)
/// exists — no backend calls.
library;

import 'package:flutter/material.dart';

import '../models/settings_group.dart';
import '../models/settings_item.dart';
import '../models/storage_stats.dart';
import '../models/user_profile.dart';

const UserProfile mockUserProfile = UserProfile(
  name: 'Kelechi Omeire',
  email: 'kelechi@dastorytella.app',
  avatarInitial: 'K',
  planLabel: 'FREE',
);

const StorageStats mockStorageStats = StorageStats(
  usedGb: 1.8,
  totalGb: 4,
  booksFraction: 0.32,
  voicesFraction: 0.14,
);

final List<SettingsGroup> mockSettingsGroups = <SettingsGroup>[
  const SettingsGroup(
    label: 'Reading & Playback',
    items: <SettingsItem>[
      SettingsItem(
        icon: Icons.record_voice_over_outlined,
        title: 'Default voice',
        subtitle: 'Used for newly imported books',
        value: 'Amara',
      ),
      SettingsItem(
        icon: Icons.speed_outlined,
        title: 'Playback speed',
        subtitle: 'Default for new sessions',
        value: '1.0×',
      ),
      SettingsItem(
        icon: Icons.notes_outlined,
        title: 'Pronunciation dictionary',
        subtitle: '12 custom entries',
      ),
    ],
  ),
  const SettingsGroup(
    label: 'Account',
    items: <SettingsItem>[
      SettingsItem(
        icon: Icons.workspace_premium_outlined,
        title: 'Upgrade to Ultra',
        subtitle: 'More cloud voices, offline packs',
      ),
      SettingsItem(
        icon: Icons.sync_outlined,
        title: 'Sync & backup',
        subtitle: 'Last synced 2 mins ago',
      ),
      SettingsItem(icon: Icons.privacy_tip_outlined, title: 'Privacy & data'),
    ],
  ),
];
