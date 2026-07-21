/// Hardcoded sample library, mirroring the four books shown in the
/// Library mockup (`docs/design-reference/app-mockups-v2.html`).
///
/// Placeholder until library sync (ARCHITECTURE.md §1) exists — no
/// backend calls.
library;

import 'package:flutter/material.dart';

import '../models/book.dart';

final List<Book> mockBooks = <Book>[
  const Book(
    id: 'le-salon-caramel',
    title: 'Le Salon Caramel',
    byline: 'Amara · Warm Narrative',
    spineLabel: 'LE SALON\nCARAMEL',
    coverGradient: <Color>[Color(0xFF8A3A3F), Color(0xFF4C1C20)],
    progress: 0.38,
    isDownloaded: true,
  ),
  const Book(
    id: 'blood-of-the-plateau',
    title: 'Blood of the Plateau',
    byline: 'Kwame · Deep Cinematic',
    spineLabel: 'BLOOD OF\nTHE PLATEAU',
    coverGradient: <Color>[Color(0xFF3D5A4E), Color(0xFF1F3129)],
    progress: 0.12,
    isDownloaded: true,
  ),
  const Book(
    id: 'anatomy-of-a-prompt',
    title: 'Anatomy of a Prompt',
    byline: 'Nadia · Clear & Brisk',
    spineLabel: 'ANATOMY OF\nA PROMPT',
    coverGradient: <Color>[Color(0xFFC98A2E), Color(0xFF7A5218)],
    progress: 1.0,
  ),
  const Book(
    id: 'blue-marie',
    title: 'Blue Marie (draft)',
    byline: 'You · Write-in text',
    spineLabel: 'BLUE MARIE',
    coverGradient: <Color>[Color(0xFF4A4266), Color(0xFF241F3D)],
    progress: 0.05,
  ),
];
