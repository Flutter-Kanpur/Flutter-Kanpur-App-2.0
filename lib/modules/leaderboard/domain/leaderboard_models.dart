import 'package:equatable/equatable.dart';

/// One row of `leaderboard_entries` joined with the member's `users` row.
/// No photo: the leaderboard UI shows no avatars, so `photo_url` isn't fetched.
class LeaderboardEntry extends Equatable {
  const LeaderboardEntry({
    required this.userId,
    required this.name,
    required this.rank,
    required this.points,
  });

  final String userId;
  final String name;
  final int rank;
  final int points;

  /// First word of [name], for the small top-3 balloons.
  String get shortName {
    final first = name.trim().split(RegExp(r'\s+')).first;
    return first.isEmpty ? name : first;
  }

  /// [row] is a `leaderboard_entries` row with the member embedded as `user`.
  /// [fallbackName] is used when the member has no name at all.
  factory LeaderboardEntry.fromMap(
    Map<String, dynamic> row, {
    required String fallbackName,
  }) {
    final user = row['user'] is Map<String, dynamic>
        ? row['user'] as Map<String, dynamic>
        : const <String, dynamic>{};
    final name = [user['display_name'], user['full_name'], user['username']]
        .map((v) => v == null ? '' : '$v'.trim())
        .firstWhere((v) => v.isNotEmpty, orElse: () => fallbackName);

    return LeaderboardEntry(
      userId: '${row['user_uid'] ?? ''}',
      name: name,
      rank: _int(row['rank_position']),
      // `score` is NUMERIC(12,2); the UI shows whole points.
      points: _int(row['score']),
    );
  }

  static int _int(dynamic value) {
    if (value is num) return value.round();
    return num.tryParse('${value ?? ''}')?.round() ?? 0;
  }

  @override
  List<Object?> get props => [userId, name, rank, points];
}

/// The latest leaderboard snapshot, loaded page by page (infinite scroll).
class Leaderboard extends Equatable {
  const Leaderboard({
    required this.entries,
    this.snapshotId,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  static const empty = Leaderboard(entries: []);

  /// Null when no snapshot has been published yet. Every page is read from
  /// this id, so a snapshot published mid-scroll can't mix two boards.
  final String? snapshotId;

  /// Loaded rows in server order (rank, then user id). Not re-sorted here:
  /// sorting each page on the client could reorder rows across pages.
  final List<LeaderboardEntry> entries;

  /// Whether another page exists after [entries].
  final bool hasMore;

  /// A next page is being fetched.
  final bool isLoadingMore;

  /// Set when a *later* page fails, so loaded rows stay on screen. A
  /// first-page failure surfaces through the AsyncValue instead.
  final Object? loadMoreError;

  bool get isEmpty => entries.isEmpty;

  /// Ranks 1-3 for the balloons.
  List<LeaderboardEntry> get podium => entries.take(3).toList();

  /// Everyone after the podium, for the list card.
  List<LeaderboardEntry> get rest => entries.skip(3).toList();

  Leaderboard copyWith({
    List<LeaderboardEntry>? entries,
    bool? hasMore,
    bool? isLoadingMore,
    Object? loadMoreError,
    bool clearLoadMoreError = false,
  }) {
    return Leaderboard(
      entries: entries ?? this.entries,
      snapshotId: snapshotId,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreError: clearLoadMoreError
          ? null
          : (loadMoreError ?? this.loadMoreError),
    );
  }

  @override
  List<Object?> get props => [
    snapshotId,
    entries,
    hasMore,
    isLoadingMore,
    loadMoreError,
  ];
}

/// A rank level on My Rank, e.g. "Consistent Learner - Level 3 of 6".
class RankLevel extends Equatable {
  const RankLevel({
    required this.level,
    required this.titleKey,
    required this.minPoints,
  });

  final int level;

  /// Translation key for the level title.
  final String titleKey;

  /// Points needed to reach this level.
  final int minPoints;

  /// Levels in ascending order. Thresholds live in the app until the backend
  /// owns rank levels.
  static const all = [
    RankLevel(level: 1, titleKey: 'myRank.levels.1', minPoints: 0),
    RankLevel(level: 2, titleKey: 'myRank.levels.2', minPoints: 50),
    RankLevel(level: 3, titleKey: 'myRank.levels.3', minPoints: 150),
    RankLevel(level: 4, titleKey: 'myRank.levels.4', minPoints: 300),
    RankLevel(level: 5, titleKey: 'myRank.levels.5', minPoints: 600),
    RankLevel(level: 6, titleKey: 'myRank.levels.6', minPoints: 1000),
  ];

  static int get count => all.length;

  /// Highest level whose threshold [points] has reached (negatives count as 0).
  static RankLevel forPoints(int points) {
    return all.lastWhere((l) => points >= l.minPoints, orElse: () => all.first);
  }

  /// The level after this one, or null at the top level.
  RankLevel? get next => level < count ? all[level] : null;

  @override
  List<Object?> get props => [level, titleKey, minPoints];
}

/// The signed-in user's standing for My Rank.
class MyRank extends Equatable {
  const MyRank({required this.points, this.rank, this.hasLeaderboard = true});

  final int points;

  /// Position on the latest leaderboard; null if the user isn't on it.
  final int? rank;

  /// False when no leaderboard has been published yet.
  final bool hasLeaderboard;

  bool get isRanked => rank != null;

  RankLevel get level => RankLevel.forPoints(points);

  /// 0.0 - 1.0 toward the next level; 1.0 at the top level.
  double get progressToNext {
    final next = level.next;
    if (next == null) return 1;
    final span = next.minPoints - level.minPoints;
    return ((points - level.minPoints) / span).clamp(0.0, 1.0);
  }

  /// Points still needed for the next level; 0 at the top level.
  int get pointsToNext {
    final next = level.next;
    return next == null
        ? 0
        : (next.minPoints - points).clamp(0, next.minPoints);
  }

  @override
  List<Object?> get props => [points, rank, hasLeaderboard];
}
