class SuggestedJob {
  const SuggestedJob({
    required this.title,
    required this.tags,
    required this.companyName,
    required this.companyLogoUrl,
    required this.location,
    required this.isSaved,
  });

  final String title;
  final List<String> tags;
  final String companyName;
  final String companyLogoUrl;
  final String location;
  final bool isSaved;
}
