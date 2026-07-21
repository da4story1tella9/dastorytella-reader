/// Signed-in user summary card. Mirrors `.profile-card` in
/// `docs/design-reference/app-mockups-core-batch1.html`.
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../models/user_profile.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({required this.profile, super.key});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[AppColors.gold, AppColors.maroon],
              ),
            ),
            child: Text(
              profile.avatarInitial,
              style: AppTypography.bookTitle.copyWith(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  profile.name,
                  style: AppTypography.bodyStrong.copyWith(fontSize: 14.5),
                ),
                const SizedBox(height: 2),
                Text(
                  profile.email,
                  style: AppTypography.body.copyWith(
                    color: AppColors.inkSoft,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.maroonPale,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              profile.planLabel,
              style: AppTypography.caption.copyWith(
                color: AppColors.maroon,
                fontSize: 9.5,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
