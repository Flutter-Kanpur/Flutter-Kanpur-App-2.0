class ContributorApplicationDraft {
  const ContributorApplicationDraft({
    required this.fullName,
    required this.email,
    required this.currentRole,
    required this.contributionArea,
    required this.skills,
    required this.experienceLevel,
    required this.weeklyHours,
    this.githubUrl,
    this.linkedinUrl,
    this.websiteUrl,
    this.whyContribute,
  });

  final String fullName;
  final String email;
  final String currentRole;
  final String contributionArea;
  final List<String> skills;
  final String experienceLevel;
  final String weeklyHours;
  final String? githubUrl;
  final String? linkedinUrl;
  final String? websiteUrl;
  final String? whyContribute;

  /// Serializes draft into Supabase `contributor_applications` table column names.
  Map<String, dynamic> toSupabaseMap(String userUid) {
    return {
      'user_uid': userUid,
      'full_name': fullName.trim(),
      'email': email.trim(),
      'job_role': currentRole.trim(),
      'contribution_option': contributionArea.trim(),
      'experience_level': experienceLevel.trim(),
      'time_per_week': weeklyHours.trim(),
      if (whyContribute != null && whyContribute!.trim().isNotEmpty)
        'why_contribute': whyContribute!.trim(),
      if (githubUrl != null && githubUrl!.trim().isNotEmpty)
        'github_url': githubUrl!.trim(),
      if (linkedinUrl != null && linkedinUrl!.trim().isNotEmpty)
        'linkedin_url': linkedinUrl!.trim(),
      if (websiteUrl != null && websiteUrl!.trim().isNotEmpty)
        'portfolio_url': websiteUrl!.trim(),
      'relevant_skills': skills,
      'status': 'pending',
    };
  }

  /// Deserializes a row from Supabase `contributor_applications`.
  factory ContributorApplicationDraft.fromSupabaseMap(Map<String, dynamic> map) {
    final rawSkills = map['relevant_skills'];
    final skillsList = rawSkills is List
        ? rawSkills.map((e) => e.toString()).toList()
        : <String>[];

    return ContributorApplicationDraft(
      fullName: map['full_name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      currentRole: map['job_role'] as String? ?? '',
      contributionArea: map['contribution_option'] as String? ?? '',
      skills: skillsList,
      experienceLevel: map['experience_level'] as String? ?? '',
      weeklyHours: map['time_per_week'] as String? ?? '',
      whyContribute: map['why_contribute'] as String?,
      githubUrl: map['github_url'] as String?,
      linkedinUrl: map['linkedin_url'] as String?,
      websiteUrl: map['portfolio_url'] as String?,
    );
  }
}
