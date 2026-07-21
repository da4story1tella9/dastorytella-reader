/// Compact "currently playing" bar pinned above the bottom nav.
/// Mirrors `.mini-player` in `docs/design-reference/app-mockups-v2.html`.
///
/// Static mock — wire to real playback state once the player feature
/// (and its Riverpod state, see ADR-0004) exists.
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../models/book.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({required this.book, required this.subtitle, super.key});

  final Book book;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x1A251D18),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: book.coverGradient,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  book.title,
                  style: AppTypography.bodyStrong.copyWith(fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: AppTypography.body.copyWith(
                    color: AppColors.inkSoft,
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: AppColors.ink,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.pause, size: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
