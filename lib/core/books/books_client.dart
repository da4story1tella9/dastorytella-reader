/// Client for the backend's book persistence routes (`POST/GET
/// /books`) — see docs/adr/0010-import-a-real-book.md and the
/// backend repo's docs/adr/0009-books-persistence.md.
library;

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/backend_config.dart';
import '../ingestion/parsed_book.dart';
import 'remote_book.dart';

class BooksRequestException implements Exception {
  const BooksRequestException(this.message);

  final String message;
}

class BooksClient {
  Future<RemoteBook> createBook({
    required String title,
    required List<ParsedChapter> chapters,
  }) async {
    final String accessToken = _requireAccessToken(
      'Sign in to save this book.',
    );

    final http.Response response;
    try {
      response = await http
          .post(
            Uri.parse('${BackendConfig.baseUrl}/books'),
            headers: <String, String>{
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(<String, dynamic>{
              'title': title,
              'chapters': chapters.map((ParsedChapter c) => c.toJson()).toList(),
            }),
          )
          .timeout(const Duration(seconds: 30));
    } catch (_) {
      throw const BooksRequestException(
        "Couldn't reach the server. Check your connection and try again.",
      );
    }

    if (response.statusCode != 201) {
      throw const BooksRequestException(
        "Couldn't save this book. Please try again shortly.",
      );
    }
    return RemoteBook.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<List<RemoteBook>> listBooks() async {
    final String accessToken = _requireAccessToken(
      'Sign in to see your library.',
    );

    final http.Response response;
    try {
      response = await http
          .get(
            Uri.parse('${BackendConfig.baseUrl}/books'),
            headers: <String, String>{'Authorization': 'Bearer $accessToken'},
          )
          .timeout(const Duration(seconds: 15));
    } catch (_) {
      throw const BooksRequestException(
        "Couldn't reach the server. Check your connection and try again.",
      );
    }

    if (response.statusCode != 200) {
      throw const BooksRequestException(
        "Couldn't load your library. Please try again shortly.",
      );
    }
    final List<dynamic> raw = jsonDecode(response.body) as List<dynamic>;
    return raw
        .map((dynamic item) => RemoteBook.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  String _requireAccessToken(String messageIfMissing) {
    final String? accessToken =
        Supabase.instance.client.auth.currentSession?.accessToken;
    if (accessToken == null) {
      throw BooksRequestException(messageIfMissing);
    }
    return accessToken;
  }
}

final Provider<BooksClient> booksClientProvider = Provider<BooksClient>(
  (Ref ref) => BooksClient(),
);
