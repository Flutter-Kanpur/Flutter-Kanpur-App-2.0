import 'package:flutter_knp_mobile_app_v2/utils/short_date_format.dart';

class CommunityProjectPreview {
  const CommunityProjectPreview({
    required this.id,
    required this.title,
    required this.techStack,
    required this.authorName,
    required this.postedOn,
    this.githubUrl,
    this.figmaUrl,
    this.liveUrl,
  });

  /// `projects.id`, used to route to the detail screen.
  final String id;
  final String title;
  final List<String> techStack;
  final String authorName;
  final String postedOn;
  final String? githubUrl;
  final String? figmaUrl;
  final String? liveUrl;

  /// Maps a `projects` row joined with `project_tech_stack` and `users`
  /// (owner). `authorName` falls back from `display_name` to `full_name`.
  factory CommunityProjectPreview.fromMap(Map<String, dynamic> map) {
    final owner = map['owner'] as Map<String, dynamic>?;
    final displayName = owner?['display_name'] as String?;
    final fullName = owner?['full_name'] as String?;
    final techRows = map['project_tech_stack'] as List<dynamic>? ?? const [];
    final createdAt = DateTime.tryParse(map['created_at'] as String? ?? '');

    return CommunityProjectPreview(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      techStack: techRows
          .map((t) => (t as Map<String, dynamic>)['tech_name'] as String?)
          .whereType<String>()
          .where((t) => t.isNotEmpty)
          .toList(),
      authorName: (displayName != null && displayName.isNotEmpty)
          ? displayName
          : (fullName ?? 'Member'),
      postedOn: createdAt != null
          ? '${createdAt.day} ${createdAt.shortMonth} ${createdAt.year}'
          : '',
      githubUrl: map['github_url'] as String?,
      figmaUrl: map['figma_url'] as String?,
      liveUrl: map['live_url'] as String?,
    );
  }
}
