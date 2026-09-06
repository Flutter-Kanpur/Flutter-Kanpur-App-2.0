import 'package:flutter_knp_mobile_app_v2/core/database/database_tables.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/community_project_detail.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/community_project_preview.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/core_team_member.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExploreRepository {
  ExploreRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  /// Active core team from [DatabaseTables.coreTeamMembers], paginated.
  Future<List<CoreTeamMember>> fetchCoreTeamMembers({
    int limit = 10,
    int offset = 0,
  }) async {
    final data = await _client
        .from(DatabaseTables.coreTeamMembers)
        .select(
          'role, team_section, is_lead, sort_order, is_active, joined_at, '
          'user:users!user_uid('
          'display_name, full_name, username, photo_url, bio, '
          'github_url, linkedin_url, website_url, '
          'user_skills(skill_name)'
          ')',
        )
        .eq('is_active', true)
        .eq('is_deleted', false)
        .order('sort_order', ascending: true)
        .order('joined_at', ascending: false)
        .range(offset, offset + limit - 1);

    return (data as List<dynamic>)
        .map((m) => CoreTeamMember.fromMap(m as Map<String, dynamic>))
        .toList();
  }

  static const _projectListSelect =
      'id, title, created_at, github_url, figma_url, live_url, '
      'project_tech_stack(tech_name), '
      'owner:users!owner_uid(display_name, full_name)';

  /// Newest admin-approved (`status = active`) projects, public to all users.
  Future<List<CommunityProjectPreview>> fetchLatestCommunityProjects({
    int limit = 2,
    int offset = 0,
  }) async {
    final data = await _client
        .from(DatabaseTables.projects)
        .select(_projectListSelect)
        .eq('status', 'active')
        .eq('is_deleted', false)
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return (data as List<dynamic>)
        .map(
          (p) => CommunityProjectPreview.fromMap(p as Map<String, dynamic>),
        )
        .toList();
  }

  /// Public approved projects filtered by `title ilike` [query].
  Future<List<CommunityProjectPreview>> searchProjects(
    String query, {
    int limit = 20,
  }) async {
    final data = await _client
        .from(DatabaseTables.projects)
        .select(_projectListSelect)
        .eq('status', 'active')
        .eq('is_deleted', false)
        .ilike('title', '%$query%')
        .order('created_at', ascending: false)
        .limit(limit);

    return (data as List<dynamic>)
        .map(
          (p) => CommunityProjectPreview.fromMap(p as Map<String, dynamic>),
        )
        .toList();
  }

  /// Single approved project by id, plus [_fetchSharedOn] for the "Shared on" date.
  Future<CommunityProjectDetail> fetchProjectById(String projectId) async {
    final data = await _client
        .from(DatabaseTables.projects)
        .select(
          'id, title, summary, description, cover_image_url, owner_uid, '
          'github_url, figma_url, live_url, '
          'project_tech_stack(tech_name), '
          'owner:users!owner_uid(display_name, full_name)',
        )
        .eq('id', projectId)
        .eq('status', 'active')
        .eq('is_deleted', false)
        .single();

    final sharedOn = await _fetchSharedOn(
      projectId: projectId,
      ownerUid: data['owner_uid'] as String?,
    );
    return CommunityProjectDetail.fromMap(data, sharedOn: sharedOn);
  }

  Future<DateTime?> _fetchSharedOn({
    required String projectId,
    required String? ownerUid,
  }) async {
    final currentUserId = _client.auth.currentUser?.id;
    if (currentUserId == null || currentUserId == ownerUid) return null;

    final membership = await _client
        .from(DatabaseTables.projectMembers)
        .select('joined_at')
        .eq('project_id', projectId)
        .eq('user_uid', currentUserId)
        .eq('active', true)
        .maybeSingle();
    if (membership == null) return null;

    return DateTime.tryParse(membership['joined_at'] as String? ?? '');
  }
}
