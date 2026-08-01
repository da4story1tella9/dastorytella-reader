/// Pronunciation dictionary screen — add-entry form and the entry
/// list. Mirrors
/// `docs/design-reference/app-mockups-secondary-batch.html`.
///
/// Unlike most other screens this session, the form is genuinely
/// interactive: adding/removing entries really mutates
/// `pronunciationEntriesProvider` (see `state/pronunciation_providers.dart`),
/// not just local UI state — no backend persistence yet, though.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared_widgets/app_icon_button.dart';
import '../models/pronunciation_entry.dart';
import '../state/pronunciation_providers.dart';
import '../widgets/add_entry_card.dart';
import '../widgets/pronunciation_entry_row.dart';

Future<bool> _confirmDelete(BuildContext context, String word) async {
  final bool? confirmed = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: Text(
        'Delete "$word"?',
        style: AppTypography.bookTitle.copyWith(fontSize: 17),
      ),
      content: Text(
        "This removes the pronunciation override. It can't be undone.",
        style: AppTypography.body.copyWith(
          color: AppColors.inkSoft,
          fontSize: 12.5,
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'Cancel',
            style: AppTypography.bodyStrong.copyWith(
              color: AppColors.inkSoft,
              fontSize: 13,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            'Delete',
            style: AppTypography.bodyStrong.copyWith(
              color: AppColors.maroon,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}

class PronunciationDictionaryScreen extends ConsumerWidget {
  const PronunciationDictionaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<PronunciationEntry> entries = ref.watch(
      pronunciationEntriesProvider,
    );
    final PronunciationDictionaryController controller = ref.read(
      pronunciationEntriesProvider.notifier,
    );

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                AppIconButton(
                  icon: Icons.arrow_back,
                  onTap: () => context.canPop()
                      ? context.pop()
                      : context.go('/settings'),
                ),
                const Text(
                  'Pronunciations',
                  style: TextStyle(
                    fontFamily: AppTypography.serifFamily,
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
                AppIconButton(icon: Icons.search, onTap: () {}),
              ],
            ),
            const SizedBox(height: 14),
            AddEntryCard(
              onAdd: (String word, String pronunciation) => controller.add(
                PronunciationEntry(
                  word: word,
                  pronunciation: pronunciation,
                  contextLabel: 'Applies to all books',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 4, left: 2),
              child: Text(
                '${entries.length} custom '
                '${entries.length == 1 ? 'entry' : 'entries'}',
                style: AppTypography.eyebrow,
              ),
            ),
            for (int i = 0; i < entries.length; i++)
              PronunciationEntryRow(
                entry: entries[i],
                onDelete: () async {
                  final bool confirmed = await _confirmDelete(
                    context,
                    entries[i].word,
                  );
                  if (confirmed) {
                    controller.removeAt(i);
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
