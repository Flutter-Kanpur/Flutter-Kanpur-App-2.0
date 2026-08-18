import 'package:flutter_knp_mobile_app_v2/core/database/database_tables.dart';
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
  /// `users` (owner display name), restricted to `status = 'active'` and the
  /// newest [limit] rows - the only table/columns
  /// CommunityProjectsPreviewSection renders.
  Future<List<CommunityProjectPreview>> fetchLatestCommunityProjects({
    int limit = 2,
  }) async {
    final data = await _client
        .from(DatabaseTables.projects)
        .select(
          'title, created_at, '
          'project_tech_stack(tech_name), '
          'owner:users!owner_uid(display_name, full_name)',
        )
        .eq('status', 'active')
        .order('created_at', ascending: false)
        .limit(limit);

    return (data as List<dynamic>)
        .map(
          (p) => CommunityProjectPreview.fromMap(p as Map<String, dynamic>),
        )
        .toList();
  }
}
