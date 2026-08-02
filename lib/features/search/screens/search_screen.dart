/// Search results screen — live filtering across books, chapter
/// excerpts, and voices. Mirrors
/// `docs/design-reference/app-mockups-core-batch2.html`.
///
/// Unlike the mockup's static "salon" demo, this is a real search: the
/// query field genuinely drives filtering (see
/// `state/search_providers.dart`) over `mockBooks`, a small
/// illustrative `mockChapterSnippets` corpus, and `mockVoices` — no
/// backend full-text search yet (ARCHITECTURE.md §3).
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared_widgets/app_icon_button.dart';
import '../../library/models/book.dart';
import '../../library/state/mock_library_data.dart';
import '../../voices/models/voice.dart';
import '../../voices/state/mock_voices_data.dart';
import '../models/chapter_snippet.dart';
import '../state/mock_chapter_snippets.dart';
import '../state/search_providers.dart';
import '../widgets/search_book_result_row.dart';
import '../widgets/search_snippet_row.dart';
import '../widgets/search_voice_result_row.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String query = ref.watch(searchQueryProvider);
    final String lowerQuery = query.toLowerCase();

    final List<Book> matchingBooks = query.isEmpty
        ? const <Book>[]
        : mockBooks
            .where((Book b) => b.title.toLowerCase().contains(lowerQuery))
            .toList();
    final List<ChapterSnippet> matchingSnippets = query.isEmpty
        ? const <ChapterSnippet>[]
        : mockChapterSnippets
            .where(
              (ChapterSnippet s) => s.text.toLowerCase().contains(lowerQuery),
            )
            .toList();
    final List<Voice> matchingVoices = query.isEmpty
        ? const <Voice>[]
        : mockVoices
            .where(
              (Voice v) =>
                  v.name.toLowerCase().contains(lowerQuery) ||
                  v.tags.toLowerCase().contains(lowerQuery),
            )
            .toList();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: <Widget>[
            Row(
              children: <Widget>[
                AppIconButton(
                  icon: Icons.arrow_back,
                  onTap: () =>
                      context.canPop() ? context.pop() : context.go('/library'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.line),
                    ),
                    child: Row(
                      children: <Widget>[
                        const Icon(
                          Icons.search,
                          size: 16,
                          color: AppColors.inkFaint,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            autofocus: true,
                            style: AppTypography.bodyStrong.copyWith(
                              fontSize: 13.5,
                            ),
                            decoration: const InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              hintText: 'Search books, chapters, voices',
                              hintStyle: AppTypography.body,
                            ),
                            onChanged: (String value) => ref
                                .read(searchQueryProvider.notifier)
                                .state = value,
                          ),
                        ),
                        if (query.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _controller.clear();
                              ref.read(searchQueryProvider.notifier).state = '';
                            },
                            child: const Icon(
                              Icons.close,
                              size: 15,
                              color: AppColors.inkFaint,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (query.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Center(
                  child: Text(
                    'Search your library',
                    style: AppTypography.body.copyWith(
                      color: AppColors.inkFaint,
                    ),
                  ),
                ),
              )
            else ...<Widget>[
              const _SectionLabel('Books'),
              if (matchingBooks.isEmpty)
                const _EmptySectionHint('No matching books')
              else
                for (final Book book in matchingBooks)
                  SearchBookResultRow(book: book, query: query),
              const _SectionLabel('Matching chapters'),
              if (matchingSnippets.isEmpty)
                const _EmptySectionHint('No matching chapters')
              else
                for (final ChapterSnippet snippet in matchingSnippets)
                  SearchSnippetRow(snippet: snippet, query: query),
              const _SectionLabel('Voices'),
              if (matchingVoices.isEmpty)
                const _EmptySectionHint('No matching voices')
              else
                for (final Voice voice in matchingVoices)
                  SearchVoiceResultRow(voice: voice, query: query),
              const SizedBox(height: 8),
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  margin: const EdgeInsets.only(top: 14),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceAlt,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: <Widget>[
                      const Icon(
                        Icons.public,
                        size: 15,
                        color: AppColors.inkSoft,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Can\'t find it? Import "$query" from the web →',
                          style: AppTypography.bodyStrong.copyWith(
                            color: AppColors.inkSoft,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 4, left: 2),
      child: Text(label.toUpperCase(), style: AppTypography.eyebrow),
    );
  }
}

class _EmptySectionHint extends StatelessWidget {
  const _EmptySectionHint(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Text(
        text,
        style: AppTypography.body.copyWith(
          color: AppColors.inkFaint,
          fontSize: 12,
        ),
      ),
    );
  }
}
