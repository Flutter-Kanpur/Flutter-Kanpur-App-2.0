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

  /// `projects.id` - not consumed yet (no project detail screen exists), kept
  /// on the model so it's ready to pass through once "View project details"
  /// has somewhere to navigate to.
  final String id;
  final String title;
  final List<String> techStack;
  final String authorName;
  final String postedOn;
  final String? githubUrl;
  final String? figmaUrl;
  final String? liveUrl;

  /// [map] is one row of `projects` joined with `project_tech_stack` via
  /// `project_tech_stack(tech_name)` and `users` (owner) via
  /// `owner:users!owner_uid(display_name, full_name)` - only the columns
  /// CommunityProjectPreviewCard renders. `authorName` prefers `display_name`
  /// (falling back to `full_name`, then a placeholder), same convention as
  /// CoreTeamMember.fromMap.
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
