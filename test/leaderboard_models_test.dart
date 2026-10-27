import 'package:flutter_knp_mobile_app_v2/modules/leaderboard/domain/leaderboard_models.dart';
import 'package:flutter_test/flutter_test.dart';

LeaderboardEntry _entry(String name, int rank, int points) =>
    LeaderboardEntry(userId: name, name: name, rank: rank, points: points);

void main() {
  group('LeaderboardEntry.fromMap', () {
    test('reads rank, rounds NUMERIC score and prefers display_name', () {
      final entry = LeaderboardEntry.fromMap({
        'user_uid': 'u1',
        'rank_position': 4,
        'score': 55.6,
        'user': {
          'display_name': 'Pushti Sonawala',
          'full_name': 'Pushti S',
          'photo_url': 'https://cdn.example.com/p.png',
        },
      }, fallbackName: 'Member');

      expect(entry.userId, 'u1');
      expect(entry.rank, 4);
      expect(entry.points, 56);
      expect(entry.name, 'Pushti Sonawala');
      expect(entry.shortName, 'Pushti');
      expect(entry.photoUrl, 'https://cdn.example.com/p.png');
    });

    test('falls back through full_name, username, then fallbackName', () {
      Map<String, dynamic> row(Map<String, dynamic>? user) => {
        'user_uid': 'u1',
        'rank_position': 1,
        'score': '80',
        'user': user,
      };

      expect(
        LeaderboardEntry.fromMap(
          row({'display_name': '  ', 'full_name': 'Akash Kumar'}),
          fallbackName: 'Member',
        ).name,
        'Akash Kumar',
      );
      expect(
        LeaderboardEntry.fromMap(
          row({'username': 'naman'}),
          fallbackName: 'Member',
        ).name,
        'naman',
      );
      final hidden = LeaderboardEntry.fromMap(
        row(null),
        fallbackName: 'Member',
      );
      expect(hidden.name, 'Member');
      expect(hidden.points, 80);
      expect(hidden.photoUrl, isNull);
    });

    test('bad numbers become 0', () {
      final entry = LeaderboardEntry.fromMap({
        'user_uid': 'u1',
        'rank_position': null,
        'score': 'abc',
      }, fallbackName: 'Member');

      expect(entry.rank, 0);
      expect(entry.points, 0);
    });
  });

  group('Leaderboard', () {
    test('sorted by rank, ties by points then name; podium/rest split', () {
      final board = Leaderboard(
        entries: Leaderboard.sorted([
          _entry('Utsav', 7, 55),
          _entry('Angie', 1, 250),
          _entry('Naman', 3, 60),
          _entry('Ayush', 6, 55),
          _entry('Akash', 2, 80),
          _entry('Aneesh', 5, 55),
          _entry('Pushti', 4, 55),
          _entry('Bob', 7, 55),
        ]),
      );

      expect(board.podium.map((e) => e.name), ['Angie', 'Akash', 'Naman']);
      expect(board.rest.map((e) => e.name), [
        'Pushti',
        'Aneesh',
        'Ayush',
        'Bob',
        'Utsav',
      ]);
    });

    test('fewer than 3 entries: podium only, empty rest', () {
      final board = Leaderboard(entries: [_entry('Angie', 1, 250)]);
      expect(board.podium, hasLength(1));
      expect(board.rest, isEmpty);
      expect(Leaderboard.empty.isEmpty, isTrue);
    });
  });

  group('RankLevel / MyRank', () {
    test('level thresholds', () {
      expect(RankLevel.forPoints(-5).level, 1);
      expect(RankLevel.forPoints(0).level, 1);
      expect(RankLevel.forPoints(49).level, 1);
      expect(RankLevel.forPoints(50).level, 2);
      expect(RankLevel.forPoints(150).level, 3);
      expect(RankLevel.forPoints(999).level, 5);
      expect(RankLevel.forPoints(5000).level, 6);
      expect(RankLevel.count, 6);
    });

    test('progress toward next level', () {
      const rank = MyRank(points: 200, rank: 9); // level 3: 150..300
      expect(rank.level.level, 3);
      expect(rank.level.next?.level, 4);
      expect(rank.pointsToNext, 100);
      expect(rank.progressToNext, closeTo(50 / 150, 0.0001));
      expect(rank.isRanked, isTrue);
    });

    test('top level is full with nothing to next', () {
      const rank = MyRank(points: 1500, rank: 1);
      expect(rank.level.next, isNull);
      expect(rank.pointsToNext, 0);
      expect(rank.progressToNext, 1);
    });

    test('unranked user is level 1 with empty progress', () {
      const rank = MyRank(points: 0);
      expect(rank.isRanked, isFalse);
      expect(rank.hasLeaderboard, isTrue);
      expect(rank.level.level, 1);
      expect(rank.progressToNext, 0);
      expect(rank.pointsToNext, 50);
    });
  });
}
