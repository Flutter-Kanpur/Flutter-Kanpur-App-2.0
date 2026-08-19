import 'package:flutter_knp_mobile_app_v2/core/database/database_tables.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/community_project_detail.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/community_project_preview.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/core_team_member.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Real (Supabase-backed) data for Explore sections that have moved off
/// [ExploreLocalDataSource]'s sample data. Kept as a separate class so the
/// remaining sample-data sections are unaffected as they migrate one at a
/// time - mirrors CommunityRepository's constructor/query style.
class ExploreRepository {
  ExploreRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  /// `community_memberships` joined with `users`, restricted to only the
  /// columns the Core Team preview needs: community_key/role/membership_status
  /// from the membership row, display_name/full_name/photo_url from the user.
  /// No status filter yet - fetches every row - and paginated via
  /// [limit]/[offset] the same way CommunityRepository.fetchReplies does.
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

  /// `projects` joined with `project_tech_stack` (tech chip names) and
  /// `users` (owner display name), restricted to `status = 'active'`,
  /// [_visibleProjectIds] (owned or shared - see there), and the newest
  /// [limit] rows starting at [offset] - the only table/columns
  /// CommunityProjectsPreviewSection (and the paginated all-projects screen)
  /// render.
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

  /// Same shape/columns/visibility rule as [fetchLatestCommunityProjects],
  /// but matched against [query] server-side (`ilike` on `title`) instead of
  /// just the newest rows - the actual search, not a frontend-only filter of
  /// whatever happens to already be loaded.
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

  /// Ids of every project visible to the current user: owned by them
  /// (`owner_uid`), or shared with them via an active `project_members` row.
  /// "Community Projects" is no longer a public browse of every active
  /// project - it's the signed-in user's own plus whatever's been shared
  /// with them, same membership concept [_fetchSharedOn] already uses for
  /// the detail screen. Two lightweight id-only queries, rather than one
  /// query trying to OR across a joined table - this keeps the actual data
  /// query (in [fetchLatestCommunityProjects]/[searchProjects]) down to a
  /// plain `id IN (...)` filter.
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

  /// Single `projects` row by id, same join columns as
  /// [fetchLatestCommunityProjects] plus the detail-only fields (summary/
  /// description/cover_image_url). `owner_uid` is selected only to decide
  /// [_fetchSharedOn] below - it isn't exposed on [CommunityProjectDetail].
  ///
  /// There's no server-side "is this shared with me" flag, so it's derived
  /// here: if the viewer isn't the owner, look up their `project_members`
  /// row for this project - an active one's `joined_at` becomes `sharedOn`.
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
