/// Client for the backend's TTS proxy (`POST /tts/synthesize`,
/// `GET /tts/voices`) — see docs/adr/0007-player-real-tts.md and
/// docs/adr/0009-real-voice-selection.md. The backend holds the real
/// ElevenLabs key server-side (mobile repo's own ADR-0003); this just
/// calls it with the signed-in user's Supabase session token, which
/// the backend verifies (backend repo's ADR-0004).
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/backend_config.dart';
import 'remote_voice.dart';

/// A message safe to show directly — either the backend's own
/// AppError-shaped message (already written for end users, same
/// reasoning as Supabase's AuthException messages) or a generic
/// fallback for a request that never reached it at all.
class TTSRequestException implements Exception {
  const TTSRequestException(this.message);

  final String message;
}

class TTSClient {
  Future<Uint8List> synthesize({
    required String text,
    required String voiceId,
  }) async {
    final String accessToken = _requireAccessToken(
      'Sign in to listen to this chapter.',
    );

    final http.Response response;
    try {
      response = await http
          .post(
            Uri.parse('${BackendConfig.baseUrl}/tts/synthesize'),
            headers: <String, String>{
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(<String, String>{
              'text': text,
              'voice_id': voiceId,
            }),
          )
          .timeout(const Duration(seconds: 30));
    } catch (_) {
      // Covers network failure, timeout, and DNS/connection errors —
      // none of that detail is meaningful to show a listener.
      throw const TTSRequestException(
        "Couldn't reach the server. Check your connection and try again.",
      );
    }

    if (response.statusCode != 200) {
      // The backend's own error responses already carry a safe
      // message (see its app/core/errors.py), but this client stays
      // provider-agnostic about status-code-specific handling for
      // now — one generic message covers auth failure, rate
      // limiting, and upstream TTS failure alike.
      throw const TTSRequestException(
        "Couldn't load this chapter's narration. Please try again shortly.",
      );
    }
    return response.bodyBytes;
  }

  Future<List<RemoteVoice>> listVoices() async {
    final String accessToken = _requireAccessToken(
      'Sign in to see available voices.',
    );

    final http.Response response;
    try {
      response = await http
          .get(
            Uri.parse('${BackendConfig.baseUrl}/tts/voices'),
            headers: <String, String>{'Authorization': 'Bearer $accessToken'},
          )
          .timeout(const Duration(seconds: 15));
    } catch (_) {
      throw const TTSRequestException(
        "Couldn't reach the server. Check your connection and try again.",
      );
    }

    if (response.statusCode != 200) {
      throw const TTSRequestException(
        'Voices are temporarily unavailable. Please try again shortly.',
      );
    }

    final List<dynamic> raw = jsonDecode(response.body) as List<dynamic>;
    return raw
        .map(
          (dynamic item) => RemoteVoice.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  String _requireAccessToken(String messageIfMissing) {
    final String? accessToken =
        Supabase.instance.client.auth.currentSession?.accessToken;
    if (accessToken == null) {
      throw TTSRequestException(messageIfMissing);
    }
    return accessToken;
  }
}

/// FastAPI-dependency-style indirection (same reasoning as the
/// backend's own `get_tts_client`) — lets tests override this with a
/// stub `TTSClient` subclass instead of a real network call.
final Provider<TTSClient> ttsClientProvider = Provider<TTSClient>(
  (Ref ref) => TTSClient(),
);
