import 'package:flutter_knp_mobile_app_v2/core/database/database_tables.dart';
import 'package:flutter_knp_mobile_app_v2/modules/badges/domain/achievement_badge.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BadgesRepository {
  BadgesRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  /// PostgREST codes for "table not found" - `badge_progress` doesn't exist
  /// until migration 006 is applied.
  static const _missingTableCodes = {'PGRST205', '42P01'};

  /// Every active badge, merged with [userId]'s assignments and progress.
  /// A null [userId] (signed out) returns every badge as locked.
  Future<List<AchievementBadge>> fetchBadgesForUser(String? userId) async {
    // `*` rather than a column list so a not-yet-migrated `badges` table
    // (no category/target columns) still loads.
    final badgesFuture = _client
        .from(DatabaseTables.badges)
        .select()
        .eq('active', true);

    final results = await Future.wait<List<dynamic>>([
      badgesFuture,
      userId == null ? Future.value(const []) : _fetchAssignments(userId),
      userId == null ? Future.value(const []) : _fetchProgress(userId),
    ]);

    final assignmentByBadge = {
      for (final row in results[1].cast<Map<String, dynamic>>())
        '${row['badge_id']}': row,
    };
    final progressByBadge = {
      for (final row in results[2].cast<Map<String, dynamic>>())
        '${row['badge_id']}': (row['current_count'] as num?)?.toInt(),
    };

    return results[0].cast<Map<String, dynamic>>().map((badge) {
      final id = '${badge['id']}';
      return AchievementBadge.fromRows(
        badge,
        assignment: assignmentByBadge[id],
        progressCount: progressByBadge[id],
      );
    }).toList();
  }

  Future<List<dynamic>> _fetchAssignments(String userId) {
    return _client
        .from(DatabaseTables.badgeAssignments)
        .select('badge_id, awarded_at')
        .eq('user_uid', userId);
  }

  Future<List<dynamic>> _fetchProgress(String userId) async {
    try {
      return await _client
          .from(DatabaseTables.badgeProgress)
          .select('badge_id, current_count')
          .eq('user_uid', userId);
    } on PostgrestException catch (e) {
      if (_missingTableCodes.contains(e.code)) return const [];
      rethrow;
    }
  }
}
