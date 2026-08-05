/// Maps a raw backend `RemoteVoice` (core/tts/remote_voice.dart) onto
/// the UI-facing `Voice` model — see docs/adr/0009-real-voice-selection.md.
library;

import 'package:flutter/material.dart';

import '../../../core/tts/remote_voice.dart';
import '../models/voice.dart';

// A small fixed palette to pick an avatar gradient from, matching the
// four hand-picked gradients the mock data used — real voices don't
// carry a color, so one is assigned deterministically by voice ID
// (stable across rebuilds, not random per frame).
const List<List<Color>> _avatarGradients = <List<Color>>[
  <Color>[Color(0xFFC98A2E), Color(0xFF8A5A1C)],
  <Color>[Color(0xFF7A2E34), Color(0xFF3F1418)],
  <Color>[Color(0xFF5C8A5C), Color(0xFF2F4C2F)],
  <Color>[Color(0xFF4A4266), Color(0xFF241F3D)],
];

Voice toUiVoice(RemoteVoice remote) {
  final List<Color> gradient =
      _avatarGradients[remote.voiceId.hashCode.abs() % _avatarGradients.length];
  final String name = _displayName(remote.name);

  return Voice(
    id: remote.voiceId,
    name: name,
    avatarInitial: name.isNotEmpty ? name[0].toUpperCase() : '?',
    avatarGradient: gradient,
    tags: _tagsLine(remote),
    isOfflineReady: false,
    description: (remote.description?.isNotEmpty ?? false)
        ? remote.description!
        : 'A narration voice available through ElevenLabs.',
    previewUrl: remote.previewUrl,
  );
}

// ElevenLabs' own names are often "Roger - Laid-Back, Casual,
// Resonant" — the part before the first " - " reads as a clean single
// name, matching the mock data's style ("Amara", "Kwame").
String _displayName(String rawName) => rawName.split(' - ').first.trim();

String _tagsLine(RemoteVoice remote) {
  final List<String> parts = <String>[
    if (remote.labels.accent != null)
      '${_humanize(remote.labels.accent!)} accent',
    if (remote.labels.useCase != null) _humanize(remote.labels.useCase!),
  ];
  if (parts.isEmpty) {
    return remote.category != null ? _humanize(remote.category!) : 'Voice';
  }
  return parts.join(' · ');
}

String _humanize(String raw) => raw
    .split('_')
    .map(
      (String word) => word.isEmpty
          ? word
          : '${word[0].toUpperCase()}${word.substring(1)}',
    )
    .join(' ');
