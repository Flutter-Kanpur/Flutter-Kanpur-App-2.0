import 'package:flutter_knp_mobile_app_v2/core/database/database_tables.dart';
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
}
