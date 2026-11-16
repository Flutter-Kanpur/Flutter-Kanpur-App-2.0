import 'package:flutter_knp_mobile_app_v2/core/database/database_tables.dart';
import 'package:flutter_knp_mobile_app_v2/modules/leaderboard/domain/leaderboard_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// One page of `leaderboard_entries` plus whether more rows follow it.
typedef LeaderboardPage = ({List<LeaderboardEntry> entries, bool hasMore});

/// Reads the newest `leaderboard_snapshots` row and its `leaderboard_entries`.
/// Snapshots are written by the backend/admin; the app only reads them.
class LeaderboardRepository {
  LeaderboardRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  /// The `snapshot_type` both Leaderboard and My Rank read from, so the two
  /// screens never show different kinds of board (e.g. weekly vs all-time).
  ///
  /// While null the type filter is skipped and the newest snapshot of any
  /// type is used (the original behaviour), so the board doesn't go blank
  /// before the value is decided.
  // TODO: set to the backend's snapshot_type value before release.
  static const String? snapshotType = null;

  /// Only the columns the UI renders. `username` stays because it's the last
  /// non-empty name fallback in [LeaderboardEntry.fromMap].
  static const _entrySelect =
      'user_uid, rank_position, score, '
      'user:users!user_uid(display_name, full_name, username)';

  /// Id of the newest snapshot of [snapshotType], or null if none exists.
  Future<String?> fetchLatestSnapshotId() => _latestSnapshotId();

  /// Rows [offset]..[offset] + [limit] - 1 of [snapshotId], best rank first.
  ///
  /// Asks for one extra row to learn whether another page exists without a
  /// count query. `user_uid` breaks `rank_position` ties so offset paging is
  /// stable: tied rows can't be skipped or repeated across page boundaries.
  Future<LeaderboardPage> fetchEntriesPage({
    required String snapshotId,
    required int offset,
    required int limit,
    required String fallbackName,
  }) async {
    final rows = await _client
        .from(DatabaseTables.leaderboardEntries)
        .select(_entrySelect)
        .eq('snapshot_id', snapshotId)
        .order('rank_position', ascending: true)
        .order('user_uid', ascending: true)
        .range(offset, offset + limit);

    final hasMore = rows.length > limit;
    return (
      entries: rows
          .take(limit)
          .map((r) => LeaderboardEntry.fromMap(r, fallbackName: fallbackName))
          .toList(),
      hasMore: hasMore,
    );
  }

  /// [userId]'s standing on the latest snapshot. Queried directly so users
  /// ranked below the loaded pages still get their rank. `.maybeSingle()` is
  /// safe: `(snapshot_id, user_uid)` is unique in the schema.
  Future<MyRank> fetchMyRank(String? userId) async {
    final snapshotId = await _latestSnapshotId();
    if (snapshotId == null) {
      return const MyRank(points: 0, hasLeaderboard: false);
    }
    if (userId == null) return const MyRank(points: 0);

    final row = await _client
        .from(DatabaseTables.leaderboardEntries)
        .select('rank_position, score')
        .eq('snapshot_id', snapshotId)
        .eq('user_uid', userId)
        .maybeSingle();
    if (row == null) return const MyRank(points: 0);

    final entry = LeaderboardEntry.fromMap(row, fallbackName: '');
    return MyRank(points: entry.points, rank: entry.rank);
  }

  /// Selects only `id`: `generated_at` is used for ordering, never shown.
  /// Uses the `(snapshot_type, generated_at)` index once [snapshotType] is set.
  Future<String?> _latestSnapshotId() async {
    var query = _client.from(DatabaseTables.leaderboardSnapshots).select('id');
    if (snapshotType != null) {
      query = query.eq('snapshot_type', snapshotType!);
    }
    final row = await query
        .order('generated_at', ascending: false)
        .limit(1)
        .maybeSingle();
    return row == null ? null : '${row['id']}';
  }
}
