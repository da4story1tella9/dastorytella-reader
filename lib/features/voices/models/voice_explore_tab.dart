/// Explore / Recents / Favorites chip row on the Voices screen.
enum VoiceExploreTab { explore, recents, favorites }

extension VoiceExploreTabLabel on VoiceExploreTab {
  String get label {
    switch (this) {
      case VoiceExploreTab.explore:
        return 'Explore';
      case VoiceExploreTab.recents:
        return 'Recents';
      case VoiceExploreTab.favorites:
        return 'Favorites';
    }
  }
}
