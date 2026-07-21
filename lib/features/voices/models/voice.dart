import 'package:flutter/material.dart';

/// Display model for a TTS voice.
///
/// Backed by hardcoded sample data (see `state/mock_voices_data.dart`)
/// until the voice catalog (ARCHITECTURE.md §1) is wired up.
class Voice {
  const Voice({
    required this.id,
    required this.name,
    required this.avatarInitial,
    required this.avatarGradient,
    required this.tags,
    required this.isOfflineReady,
  });

  final String id;
  final String name;
  final String avatarInitial;
  final List<Color> avatarGradient;

  /// e.g. "Warm, African-accented · Narrative & Story"
  final String tags;
  final bool isOfflineReady;
}
