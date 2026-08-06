/// Client for the backend's ingestion endpoint (`POST
/// /ingestion/parse`) — see docs/adr/0010-import-a-real-book.md and
/// the backend repo's docs/adr/0008-epub-ingestion.md. Turns a raw
/// EPUB file into structured chapters; doesn't save anything (see
/// BooksClient for that).
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/backend_config.dart';
import 'parsed_book.dart';

/// A message safe to show directly — the backend's own AppError
/// message, or a generic fallback for a request that never reached
/// it (same reasoning as TTSRequestException).
class IngestionRequestException implements Exception {
  const IngestionRequestException(this.message);

  final String message;
}

class IngestionClient {
  Future<ParsedBook> parseEpub({
    required Uint8List bytes,
    required String filename,
  }) async {
    final String? accessToken =
        Supabase.instance.client.auth.currentSession?.accessToken;
    if (accessToken == null) {
      throw const IngestionRequestException('Sign in to import a book.');
    }

    final http.StreamedResponse streamed;
    try {
      final http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse('${BackendConfig.baseUrl}/ingestion/parse'),
      )
        ..headers['Authorization'] = 'Bearer $accessToken'
        ..files.add(
          http.MultipartFile.fromBytes('file', bytes, filename: filename),
        );
      streamed = await request.send().timeout(BackendConfig.uploadTimeout);
    } catch (_) {
      throw const IngestionRequestException(
        "Couldn't reach the server. Check your connection and try again.",
      );
    }

    final http.Response response = await http.Response.fromStream(streamed);
    if (response.statusCode != 200) {
      // The backend's error responses carry a safe message of their
      // own (see its app/core/errors.py) — pull it through directly
      // where present rather than only ever showing one generic line,
      // since "not an EPUB" vs "file too large" are both genuinely
      // useful for the person picking the file to know.
      final String? backendMessage = _tryExtractBackendMessage(response.body);
      throw IngestionRequestException(
        backendMessage ??
            "Couldn't read that file. Please try a different one.",
      );
    }

    return ParsedBook.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }
}

String? _tryExtractBackendMessage(String body) {
  try {
    final Map<String, dynamic> decoded =
        jsonDecode(body) as Map<String, dynamic>;
    final Object? error = decoded['error'];
    if (error is Map<String, dynamic>) {
      final Object? message = error['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }
  } catch (_) {
    // Not JSON, or not our error shape — fall through to the generic
    // caller-supplied message instead.
  }
  return null;
}

final Provider<IngestionClient> ingestionClientProvider =
    Provider<IngestionClient>((Ref ref) => IngestionClient());
