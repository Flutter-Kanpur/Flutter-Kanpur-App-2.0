import 'package:flutter_knp_mobile_app_v2/core/database/database_tables.dart';
import 'package:flutter_knp_mobile_app_v2/modules/leaderboard/domain/leaderboard_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Reads the newest `leaderboard_snapshots` row and its `leaderboard_entries`.
/// Snapshots are written by the backend/admin; the app only reads them.
class LeaderboardRepository {
  LeaderboardRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  static const _entrySelect =
      'user_uid, rank_position, score, '
      'user:users!user_uid(display_name, full_name, username, photo_url)';

  /// Latest snapshot with its top [limit] entries. [Leaderboard.empty] when
  /// nothing has been published.
  Future<Leaderboard> fetchLatest({
    required String fallbackName,
    int limit = 100,
  }) async {
    final snapshot = await _latestSnapshot();
    if (snapshot == null) return Leaderboard.empty;

    final snapshotId = '${snapshot['id']}';
    final rows = await _client
        .from(DatabaseTables.leaderboardEntries)
        .select(_entrySelect)
        .eq('snapshot_id', snapshotId)
        .order('rank_position', ascending: true)
        .limit(limit);

    return Leaderboard(
      snapshotId: snapshotId,
      generatedAt: DateTime.tryParse(
        '${snapshot['generated_at'] ?? ''}',
      )?.toLocal(),
      entries: Leaderboard.sorted(
        rows.map(
          (r) => LeaderboardEntry.fromMap(r, fallbackName: fallbackName),
        ),
      ),
    );
  }

  /// [userId]'s standing on the latest snapshot. Queried directly so users
  /// ranked below the leaderboard list's limit still get their rank.
  Future<MyRank> fetchMyRank(String? userId) async {
    final snapshot = await _latestSnapshot();
    if (snapshot == null) return const MyRank(points: 0, hasLeaderboard: false);
    if (userId == null) return const MyRank(points: 0);

    final row = await _client
        .from(DatabaseTables.leaderboardEntries)
        .select('rank_position, score')
        .eq('snapshot_id', '${snapshot['id']}')
        .eq('user_uid', userId)
        .maybeSingle();
    if (row == null) return const MyRank(points: 0);

    final entry = LeaderboardEntry.fromMap(row, fallbackName: '');
    return MyRank(points: entry.points, rank: entry.rank);
  }

  Future<Map<String, dynamic>?> _latestSnapshot() {
    return _client
        .from(DatabaseTables.leaderboardSnapshots)
        .select('id, generated_at')
        .order('generated_at', ascending: false)
        .limit(1)
        .maybeSingle();
  }
}
