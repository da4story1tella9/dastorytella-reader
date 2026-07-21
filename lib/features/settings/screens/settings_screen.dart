/// Placeholder — full Settings screen not yet built. See
/// `docs/design-reference/app-mockups-core-batch1.html` for the target
/// design.
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 14, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Settings', style: AppTypography.screenTitle),
              Expanded(
                child: Center(
                  child: Text(
                    'Settings coming soon.',
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
