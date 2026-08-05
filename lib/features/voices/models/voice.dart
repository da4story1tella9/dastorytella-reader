import 'package:flutter/material.dart';

/// Display model for a TTS voice.
///
/// The Voices/Voice Detail screens populate this from real ElevenLabs
/// voices now (`state/voice_mapper.dart`, ADR-0009) — Search still
/// uses `state/mock_voices_data.dart` directly (out of scope for that
/// ADR), which is why this model's shape stays mock-data-compatible
/// rather than mirroring the backend's `RemoteVoice` shape 1:1.
class Voice {
  const Voice({
    required this.id,
    required this.name,
    required this.avatarInitial,
    required this.avatarGradient,
    required this.tags,
    required this.isOfflineReady,
    required this.description,
    this.previewUrl,
  });

  final String id;
  final String name;
  final String avatarInitial;
  final List<Color> avatarGradient;

  /// e.g. "Warm, African-accented · Narrative & Story"
  final String tags;
  final bool isOfflineReady;

  /// Longer-form sentence shown on the voice detail screen's hero.
  final String description;

  /// A short real audio sample, straight from ElevenLabs' public CDN
  /// — null for mock voices (Search's data), which have no real
  /// audio behind them.
  final String? previewUrl;
}
