/// Row for a single voice — avatar, name, offline-ready pill, tags,
/// preview/download actions. Mirrors `.voice-card` in
/// `docs/design-reference/app-mockups-v2.html`.
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../models/voice.dart';

class VoiceCard extends StatelessWidget {
  const VoiceCard({required this.voice, super.key});

  final Voice voice;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: voice.avatarGradient,
              ),
            ),
            child: Text(
              voice.avatarInitial,
              style: AppTypography.bookTitle.copyWith(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      voice.name,
                      style: AppTypography.bodyStrong.copyWith(fontSize: 13.5),
                    ),
                    if (voice.isOfflineReady) ...<Widget>[
                      const SizedBox(width: 6),
                      const _OfflinePill(),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  voice.tags,
                  style: AppTypography.body.copyWith(
                    color: AppColors.inkSoft,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          _VoiceActionButton(icon: Icons.play_arrow_rounded, onTap: () {}),
          const SizedBox(width: 6),
          _VoiceActionButton(
            icon: voice.isOfflineReady
                ? Icons.check_rounded
                : Icons.download_rounded,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _OfflinePill extends StatelessWidget {
  const _OfflinePill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.greenPale,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'OFFLINE READY',
        style: AppTypography.caption.copyWith(
          color: AppColors.green,
          fontSize: 9,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class _VoiceActionButton extends StatelessWidget {
  const _VoiceActionButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(icon, size: 15, color: AppColors.ink),
      ),
    );
  }
}
