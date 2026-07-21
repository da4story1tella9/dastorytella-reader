/// Current chapter's transcript, with the actively-spoken sentence
/// highlighted. Mirrors `.transcript-card` in
/// `docs/design-reference/app-mockups-v2.html`.
library;

import 'package:flutter/material.dart';

import '../../../core/playback/models/transcript_sentence.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class TranscriptCard extends StatelessWidget {
  const TranscriptCard({
    required this.sentences,
    required this.onViewFullTap,
    super.key,
  });

  final List<TranscriptSentence> sentences;
  final VoidCallback onViewFullTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text.rich(
            TextSpan(
              children: <InlineSpan>[
                for (final TranscriptSentence sentence in sentences)
                  TextSpan(
                    text: sentence.text,
                    style: AppTypography.transcriptBody.copyWith(
                      color: sentence.isActive
                          ? AppColors.ink
                          : AppColors.inkFaint,
                      fontWeight: sentence.isActive
                          ? FontWeight.w600
                          : FontWeight.w400,
                      backgroundColor: sentence.isActive
                          ? AppColors.goldPale
                          : null,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onViewFullTap,
            child: Text(
              'View full transcript →',
              style: AppTypography.caption.copyWith(
                color: AppColors.maroon,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
