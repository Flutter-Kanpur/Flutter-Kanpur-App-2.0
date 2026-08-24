class CoreTeamMember {
  const CoreTeamMember({
    required this.name,
    this.username,
    this.photoUrl,
    required this.role,
    required this.membershipStatus,
    required this.communityKey,
    this.bio,
    this.githubUrl,
    this.linkedinUrl,
    this.websiteUrl,
    this.skills = const [],
    this.joinedAt,
  });

  final String name;
  final String? username;
  final String? photoUrl;
  final String role;
  final String membershipStatus;
  final String communityKey;
  final String? bio;
  final String? githubUrl;
  final String? linkedinUrl;
  final String? websiteUrl;
  final List<String> skills;
  final DateTime? joinedAt;

  bool get hasBio => bio != null && bio!.trim().isNotEmpty;

  bool get hasUsername => username != null && username!.trim().isNotEmpty;

  bool get hasSocialLinks =>
      _hasUrl(githubUrl) || _hasUrl(linkedinUrl) || _hasUrl(websiteUrl);

  bool get hasSkills => skills.isNotEmpty;

  /// [map] is one row of `community_memberships` joined with `users` via
  /// `user:users!user_uid(...)`. `name` prefers `display_name` (falling back
  /// to `full_name`, then a placeholder).
  factory CoreTeamMember.fromMap(Map<String, dynamic> map) {
    final user = map['user'] as Map<String, dynamic>?;
    final displayName = user?['display_name'] as String?;
    final fullName = user?['full_name'] as String?;
    final skillsList = (user?['user_skills'] as List<dynamic>?) ?? const [];

    return CoreTeamMember(
      name: (displayName != null && displayName.isNotEmpty)
          ? displayName
          : (fullName ?? 'Member'),
      username: user?['username'] as String?,
      photoUrl: user?['photo_url'] as String?,
      role: map['role'] as String? ?? 'member',
      membershipStatus: map['membership_status'] as String? ?? 'pending',
      communityKey: map['community_key'] as String? ?? 'flutter_kanpur',
      bio: user?['bio'] as String?,
      githubUrl: user?['github_url'] as String?,
      linkedinUrl: user?['linkedin_url'] as String?,
      websiteUrl: user?['website_url'] as String?,
      skills: skillsList
          .map((skill) => (skill as Map)['skill_name'] as String? ?? '')
          .where((skill) => skill.isNotEmpty)
          .toList(),
      joinedAt: DateTime.tryParse(map['joined_at'] as String? ?? ''),
    );
  }

  static bool _hasUrl(String? value) =>
      value != null && value.trim().isNotEmpty;
}
