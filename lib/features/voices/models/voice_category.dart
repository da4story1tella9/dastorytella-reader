/// Narrative & Story / Conversational / Characters chip row on the
/// Voices screen.
enum VoiceCategory { narrativeAndStory, conversational, characters }

extension VoiceCategoryLabel on VoiceCategory {
  String get label {
    switch (this) {
      case VoiceCategory.narrativeAndStory:
        return 'Narrative & Story';
      case VoiceCategory.conversational:
        return 'Conversational';
      case VoiceCategory.characters:
        return 'Characters';
    }
  }
}
