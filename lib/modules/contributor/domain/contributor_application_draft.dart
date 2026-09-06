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
}
