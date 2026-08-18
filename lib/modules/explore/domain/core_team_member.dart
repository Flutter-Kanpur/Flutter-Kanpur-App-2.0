class CoreTeamMember {
  const CoreTeamMember({
    required this.name,
    this.photoUrl,
    required this.role,
    required this.membershipStatus,
    required this.communityKey,
  });

  final String name;
  final String? photoUrl;
  final String role;
  final String membershipStatus;
  final String communityKey;

  /// [map] is one row of `community_memberships` joined with `users` via
  /// `user:users!user_uid(display_name, full_name, photo_url)`. `name` prefers
  /// `display_name` (falling back to `full_name`, then a placeholder) since
  /// `display_name` is what the core team list should show.
  factory CoreTeamMember.fromMap(Map<String, dynamic> map) {
    final user = map['user'] as Map<String, dynamic>?;
    final displayName = user?['display_name'] as String?;
    final fullName = user?['full_name'] as String?;

    return CoreTeamMember(
      name: (displayName != null && displayName.isNotEmpty)
          ? displayName
          : (fullName ?? 'Member'),
      photoUrl: user?['photo_url'] as String?,
      role: map['role'] as String? ?? 'member',
      membershipStatus: map['membership_status'] as String? ?? 'pending',
      communityKey: map['community_key'] as String? ?? 'flutter_kanpur',
    );
  }
}
