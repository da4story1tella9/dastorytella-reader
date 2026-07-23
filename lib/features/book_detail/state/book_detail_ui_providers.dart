/// Book Detail screen-only UI state — not shared with other screens
/// (see ADR-0004).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/book_detail_tab.dart';

final StateProvider<BookDetailTab> bookDetailTabProvider =
    StateProvider<BookDetailTab>((Ref ref) => BookDetailTab.chapters);
