/// Row for a matching voice — reuses the same layout language as
/// `VoiceCard` but with the match highlighted.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../voices/models/voice.dart';
import 'highlighted_text.dart';

class SearchVoiceResultRow extends StatelessWidget {
  const SearchVoiceResultRow({
    required this.voice,
    required this.query,
    super.key,
  });

  final Voice voice;
  final String query;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/voice/${voice.id}'),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.line)),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
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
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  HighlightedText(
                    text: voice.name,
                    query: query,
                    style: AppTypography.bodyStrong.copyWith(fontSize: 13),
                    highlightColor: AppColors.maroon,
                  ),
                  const SizedBox(height: 1),
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
            const Icon(
              Icons.chevron_right,
              size: 16,
              color: AppColors.inkFaint,
            ),
          ],
        ),
      ),
    );
  }
}
