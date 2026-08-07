class ProfileUser {
  const ProfileUser({
    required this.uid,
    required this.email,
    required this.skills,
    this.displayName,
    this.fullName,
    this.username,
    this.photoUrl,
    this.bio,
    this.githubUrl,
    this.linkedinUrl,
    this.websiteUrl,
    this.yearsOfExperience = 0,
  });

  final String uid;
  final String email;
  final String? displayName;
  final String? fullName;
  final String? username;
  final String? photoUrl;
  final String? bio;
  final String? githubUrl;
  final String? linkedinUrl;
  final String? websiteUrl;
  final int yearsOfExperience;

  final List<String> skills;

  factory ProfileUser.fromMap(Map<String, dynamic> map) {
    final skillRows = (map['user_skills'] as List<dynamic>?) ?? const [];
    return ProfileUser(
      uid: map['uid'] as String? ?? '',
      email: map['email'] as String? ?? '',
      displayName: map['display_name'] as String?,
      fullName: map['full_name'] as String?,
      username: map['username'] as String?,
      photoUrl: map['photo_url'] as String?,
      bio: map['bio'] as String?,
      githubUrl: map['github_url'] as String?,
      linkedinUrl: map['linkedin_url'] as String?,
      websiteUrl: map['website_url'] as String?,
      yearsOfExperience: map['years_of_experience'] as int? ?? 0,
      skills: skillRows
          .map((row) => (row as Map)['skill_name'] as String? ?? '')
          .where((skill) => skill.isNotEmpty)
          .toList(),
    );
  }

  String get displayLabel {
    for (final candidate in [displayName, fullName, username]) {
      if (candidate != null && candidate.trim().isNotEmpty) {
        return candidate.trim();
      }
    }
    final localPart = email.split('@').first;
    return localPart.isEmpty ? 'Member' : localPart;
  }


  String get handle {
    final name = username?.trim() ?? '';
    return name.isEmpty ? '' : '@$name';
  }

  /// Whether [bio] holds something worth rendering.
  bool get hasBio => bio != null && bio!.trim().isNotEmpty;
}

class ProfileDraft {
  const ProfileDraft({
    required this.username,
    required this.bio,
    required this.githubUrl,
    required this.linkedinUrl,
    required this.websiteUrl,
    required this.yearsOfExperience,
  });

  final String? username;
  final String? bio;
  final String? githubUrl;
  final String? linkedinUrl;
  final String? websiteUrl;
  final int yearsOfExperience;
}
