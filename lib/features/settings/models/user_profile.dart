/// Display model for the signed-in user, shown in the profile card.
///
/// Backed by hardcoded sample data until auth (ARCHITECTURE.md §1)
/// exists — no backend calls.
class UserProfile {
  const UserProfile({
    required this.name,
    required this.email,
    required this.avatarInitial,
    required this.planLabel,
  });

  final String name;
  final String email;
  final String avatarInitial;
  final String planLabel;
}
