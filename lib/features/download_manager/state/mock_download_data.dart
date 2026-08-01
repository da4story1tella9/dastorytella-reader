/// Hardcoded sample downloads, mirroring
/// `docs/design-reference/app-mockups-secondary-batch.html`.
///
/// Placeholder until real downloads (ARCHITECTURE.md §4) exist — no
/// backend calls, no real file transfer.
library;

import 'package:flutter/material.dart';

import '../models/download_item.dart';
import '../models/download_status.dart';

final List<DownloadItem> mockDownloadItems = <DownloadItem>[
  const DownloadItem(
    id: 'kwame-voice',
    icon: Icons.record_voice_over_outlined,
    title: 'Kwame — Deep Cinematic (voice)',
    status: DownloadStatus.downloading,
    progress: 0.64,
    totalMb: 60,
  ),
  const DownloadItem(
    id: 'blood-of-the-plateau-offline',
    icon: Icons.menu_book_outlined,
    title: 'Blood of the Plateau — offline copy',
    status: DownloadStatus.queued,
    staticSubtitle: 'Queued · waiting for Wi-Fi',
  ),
  const DownloadItem(
    id: 'amara-voice',
    icon: Icons.record_voice_over_outlined,
    title: 'Amara — Warm Narrative (voice)',
    status: DownloadStatus.ready,
    staticSubtitle: '58 MB · downloaded 2 days ago',
  ),
  const DownloadItem(
    id: 'le-salon-caramel-offline',
    icon: Icons.menu_book_outlined,
    title: 'Le Salon Caramel — offline copy',
    status: DownloadStatus.ready,
    staticSubtitle: '210 MB · downloaded 5 days ago',
  ),
  const DownloadItem(
    id: 'nadia-voice',
    icon: Icons.record_voice_over_outlined,
    title: 'Nadia — Clear & Brisk (voice)',
    status: DownloadStatus.ready,
    staticSubtitle: '45 MB · downloaded 1 week ago',
  ),
];
