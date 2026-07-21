/// Hardcoded sample voices, mirroring the four shown in the Voices
/// mockup (`docs/design-reference/app-mockups-v2.html`).
///
/// Placeholder until the voice catalog (ARCHITECTURE.md §1) exists —
/// no backend calls.
library;

import 'package:flutter/material.dart';

import '../models/voice.dart';

final List<Voice> mockVoices = <Voice>[
  const Voice(
    id: 'amara',
    name: 'Amara',
    avatarInitial: 'A',
    avatarGradient: <Color>[Color(0xFFC98A2E), Color(0xFF8A5A1C)],
    tags: 'Warm, African-accented · Narrative & Story',
    isOfflineReady: true,
  ),
  const Voice(
    id: 'kwame',
    name: 'Kwame',
    avatarInitial: 'K',
    avatarGradient: <Color>[Color(0xFF7A2E34), Color(0xFF3F1418)],
    tags: 'Deep, cinematic · Narrative & Story',
    isOfflineReady: false,
  ),
  const Voice(
    id: 'nadia',
    name: 'Nadia',
    avatarInitial: 'N',
    avatarGradient: <Color>[Color(0xFF5C8A5C), Color(0xFF2F4C2F)],
    tags: 'Clear, brisk · Conversational',
    isOfflineReady: true,
  ),
  const Voice(
    id: 'tobi',
    name: 'Tobi',
    avatarInitial: 'T',
    avatarGradient: <Color>[Color(0xFF4A4266), Color(0xFF241F3D)],
    tags: 'Bright, youthful · Characters & Dialogue',
    isOfflineReady: false,
  ),
];
