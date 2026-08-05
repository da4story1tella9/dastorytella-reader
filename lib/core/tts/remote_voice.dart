/// Raw shape of a voice as returned by the backend's `GET
/// /tts/voices` (see docs/adr/0009-real-voice-selection.md) — a
/// direct mirror of the backend's sanitized `Voice`/`VoiceLabels`
/// schemas, not the UI-facing model (`features/voices/models/voice.dart`,
/// mapped from this via `voice_mapper.dart`).
library;

class RemoteVoiceLabels {
  const RemoteVoiceLabels({
    this.gender,
    this.accent,
    this.age,
    this.useCase,
    this.descriptive,
    this.language,
  });

  factory RemoteVoiceLabels.fromJson(Map<String, dynamic> json) {
    return RemoteVoiceLabels(
      gender: json['gender'] as String?,
      accent: json['accent'] as String?,
      age: json['age'] as String?,
      useCase: json['use_case'] as String?,
      descriptive: json['descriptive'] as String?,
      language: json['language'] as String?,
    );
  }

  final String? gender;
  final String? accent;
  final String? age;
  final String? useCase;
  final String? descriptive;
  final String? language;
}

class RemoteVoice {
  const RemoteVoice({
    required this.voiceId,
    required this.name,
    required this.labels,
    this.category,
    this.description,
    this.previewUrl,
  });

  factory RemoteVoice.fromJson(Map<String, dynamic> json) {
    return RemoteVoice(
      voiceId: json['voice_id'] as String,
      name: json['name'] as String,
      category: json['category'] as String?,
      description: json['description'] as String?,
      previewUrl: json['preview_url'] as String?,
      labels: RemoteVoiceLabels.fromJson(
        (json['labels'] as Map<String, dynamic>?) ?? const <String, dynamic>{},
      ),
    );
  }

  final String voiceId;
  final String name;
  final String? category;
  final String? description;
  final String? previewUrl;
  final RemoteVoiceLabels labels;
}
