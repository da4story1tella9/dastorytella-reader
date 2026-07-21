import 'settings_item.dart';

/// A labeled card of [SettingsItem] rows, e.g. "Reading & Playback".
class SettingsGroup {
  const SettingsGroup({required this.label, required this.items});

  final String label;
  final List<SettingsItem> items;
}
