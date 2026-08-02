/// Generic "not built yet" destination — used for Terms/Privacy Policy
/// (see AuthScreen) rather than fabricating placeholder legal text.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import 'app_icon_button.dart';

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Row(
                children: <Widget>[
                  AppIconButton(
                    icon: Icons.arrow_back,
                    onTap: () => context.canPop()
                        ? context.pop()
                        : context.go('/library'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(
                      Icons.construction_outlined,
                      size: 36,
                      color: AppColors.inkFaint,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      style: AppTypography.bookTitle.copyWith(fontSize: 19),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Coming soon',
                      style: AppTypography.body.copyWith(
                        color: AppColors.inkSoft,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
