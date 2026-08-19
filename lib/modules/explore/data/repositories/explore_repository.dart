import 'package:flutter_knp_mobile_app_v2/core/database/database_tables.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/community_project_detail.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/community_project_preview.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/core_team_member.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExploreRepository {
  ExploreRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  /// `community_memberships` joined with `users`, paginated via
  /// [limit]/[offset].
  Future<List<CoreTeamMember>> fetchCoreTeamMembers({
    int limit = 10,
    int offset = 0,
  }) async {
    final data = await _client
        .from(DatabaseTables.communityMemberships)
        .select(
          'community_key, role, membership_status, '
          'user:users!user_uid(display_name, full_name, photo_url)',
        )
        .order('joined_at', ascending: false)
        .range(offset, offset + limit - 1);

    return (data as List<dynamic>)
        .map((m) => CoreTeamMember.fromMap(m as Map<String, dynamic>))
        .toList();
  }

  /// Newest active projects owned by or shared with the current user (see
  /// [_visibleProjectIds]), paginated via [limit]/[offset].
  Future<List<CommunityProjectPreview>> fetchLatestCommunityProjects({
    int limit = 2,
    int offset = 0,
  }) async {
    final ids = await _visibleProjectIds();
    if (ids.isEmpty) return [];

    final data = await _client
        .from(DatabaseTables.projects)
        .select(
          'id, title, created_at, github_url, figma_url, live_url, '
          'project_tech_stack(tech_name), '
          'owner:users!owner_uid(display_name, full_name)',
        )
        .inFilter('id', ids)
        .eq('status', 'active')
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return (data as List<dynamic>)
        .map(
          (p) => CommunityProjectPreview.fromMap(p as Map<String, dynamic>),
        )
        .toList();
  }

  /// Same visibility rule as [fetchLatestCommunityProjects], filtered by
  /// `title ilike` [query].
  Future<List<CommunityProjectPreview>> searchProjects(
    String query, {
    int limit = 20,
  }) async {
    final ids = await _visibleProjectIds();
    if (ids.isEmpty) return [];

    final data = await _client
        .from(DatabaseTables.projects)
        .select(
          'id, title, created_at, github_url, figma_url, live_url, '
          'project_tech_stack(tech_name), '
          'owner:users!owner_uid(display_name, full_name)',
        )
        .inFilter('id', ids)
        .eq('status', 'active')
        .ilike('title', '%$query%')
        .order('created_at', ascending: false)
        .limit(limit);

    return (data as List<dynamic>)
        .map(
          (p) => CommunityProjectPreview.fromMap(p as Map<String, dynamic>),
        )
        .toList();
  }

  /// Ids of projects owned by or shared with the current user.
  Future<List<String>> _visibleProjectIds() async {
    final currentUserId = _client.auth.currentUser?.id;
    if (currentUserId == null) return [];

    final owned = await _client
        .from(DatabaseTables.projects)
        .select('id')
        .eq('owner_uid', currentUserId);
    final shared = await _client
        .from(DatabaseTables.projectMembers)
        .select('project_id')
        .eq('user_uid', currentUserId)
        .eq('active', true);

    final ids = <String>{
      ...(owned as List<dynamic>).map((r) => r['id'] as String),
      ...(shared as List<dynamic>).map((r) => r['project_id'] as String),
    };
    return ids.toList();
  }

  /// Single project by id, plus [_fetchSharedOn] for the "Shared on" date.
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
