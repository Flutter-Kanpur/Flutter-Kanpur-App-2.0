class CommunityProjectDetail {
  const CommunityProjectDetail({
    required this.id,
    required this.title,
    required this.summary,
    required this.description,
    required this.techStack,
    required this.authorName,
    this.coverImageUrl,
    this.githubUrl,
    this.figmaUrl,
    this.liveUrl,
    this.sharedOn,
  });

  final String id;
  final String title;
  final String summary;
  final String description;
  final List<String> techStack;
  final String authorName;
  final String? coverImageUrl;
  final String? githubUrl;
  final String? figmaUrl;
  final String? liveUrl;
  final DateTime? sharedOn;

  /// Maps a `projects` row joined with `project_tech_stack` and `users`
  /// (owner), plus the detail-only summary/description/cover fields.
  factory CommunityProjectDetail.fromMap(
    Map<String, dynamic> map, {
    DateTime? sharedOn,
  }) {
    final owner = map['owner'] as Map<String, dynamic>?;
    final displayName = owner?['display_name'] as String?;
    final fullName = owner?['full_name'] as String?;
    final techRows = map['project_tech_stack'] as List<dynamic>? ?? const [];

    return CommunityProjectDetail(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      summary: map['summary'] as String? ?? '',
      description: map['description'] as String? ?? '',
      techStack: techRows
          .map((t) => (t as Map<String, dynamic>)['tech_name'] as String?)
          .whereType<String>()
          .where((t) => t.isNotEmpty)
          .toList(),
      authorName: (displayName != null && displayName.isNotEmpty)
          ? displayName
          : (fullName ?? 'Member'),
      coverImageUrl: map['cover_image_url'] as String?,
      githubUrl: map['github_url'] as String?,
      figmaUrl: map['figma_url'] as String?,
      liveUrl: map['live_url'] as String?,
      sharedOn: sharedOn,
    );
  }
}
