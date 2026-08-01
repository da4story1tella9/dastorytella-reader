/// Dashed "add an entry" form. Mirrors `.add-entry-card` in
/// `docs/design-reference/app-mockups-secondary-batch.html` — real
/// text fields here, unlike the mockup's static "fake-input" boxes.
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class AddEntryCard extends StatefulWidget {
  const AddEntryCard({required this.onAdd, super.key});

  final void Function(String word, String pronunciation) onAdd;

  @override
  State<AddEntryCard> createState() => _AddEntryCardState();
}

class _AddEntryCardState extends State<AddEntryCard> {
  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _pronunciationController =
      TextEditingController();

  @override
  void dispose() {
    _wordController.dispose();
    _pronunciationController.dispose();
    super.dispose();
  }

  void _submit() {
    final String word = _wordController.text.trim();
    final String pronunciation = _pronunciationController.text.trim();
    if (word.isEmpty || pronunciation.isEmpty) {
      return;
    }
    widget.onAdd(word, pronunciation);
    _wordController.clear();
    _pronunciationController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'ADD AN ENTRY',
            style: AppTypography.eyebrow.copyWith(color: AppColors.inkFaint),
          ),
          const SizedBox(height: 10),
          _FakeFieldInput(
            controller: _wordController,
            hint: 'Word — e.g. "Aïssa"',
          ),
          const SizedBox(height: 8),
          _FakeFieldInput(
            controller: _pronunciationController,
            hint: 'Sounds like — e.g. "ah-EE-sah"',
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: _submit,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 9),
              decoration: BoxDecoration(
                color: AppColors.maroon,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Add to dictionary',
                textAlign: TextAlign.center,
                style: AppTypography.bodyStrong.copyWith(
                  color: Colors.white,
                  fontSize: 11.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FakeFieldInput extends StatelessWidget {
  const _FakeFieldInput({required this.controller, required this.hint});

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextField(
        controller: controller,
        style: AppTypography.body.copyWith(color: AppColors.ink, fontSize: 12),
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 9,
          ),
          hintText: hint,
          hintStyle: AppTypography.body.copyWith(
            color: AppColors.inkSoft,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
