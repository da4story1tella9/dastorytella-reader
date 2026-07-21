/// Placeholder — full Voices screen (catalog, download/preview actions)
/// not yet built. See `docs/design-reference/app-mockups-v2.html` for
/// the target design.
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class VoicesScreen extends StatelessWidget {
  const VoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 14, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Voices', style: AppTypography.screenTitle),
              Expanded(
                child: Center(
                  child: Text(
                    'Voice catalog coming soon.',
                    style: TextStyle(color: AppColors.inkSoft),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
