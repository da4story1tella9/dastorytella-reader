import 'package:flutter/material.dart';

/// A single tappable row within a [SettingsGroup].
class SettingsItem {
  const SettingsItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.value,
  });

  final IconData icon;
  final String title;
  final String? subtitle;

  /// Trailing value shown before the chevron, e.g. "Amara" or "1.0×".
  final String? value;
}
