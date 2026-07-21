/// Listen / Read switcher on the Player screen.
enum PlayerTab { listen, read }

extension PlayerTabLabel on PlayerTab {
  String get label {
    switch (this) {
      case PlayerTab.listen:
        return 'Listen';
      case PlayerTab.read:
        return 'Read';
    }
  }
}
