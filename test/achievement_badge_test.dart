import 'package:flutter_knp_mobile_app_v2/modules/badges/domain/achievement_badge.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _badgeRow({
  String id = 'b1',
  String title = '7-Day Streak',
  Object? category = 'Daily Practice',
  Object? sortOrder = 0,
  Object? targetCount = 7,
  Object? iconUrl,
}) => {
  'id': id,
  'title': title,
  'description': 'Seven days in a row.',
  'icon_url': iconUrl,
  'category': category,
  'sort_order': sortOrder,
  'target_count': targetCount,
  'progress_unit': 'days',
  'how_to_earn': 'Solve daily problems for seven consecutive days.',
  'earned_message': 'Nice streak.',
};

void main() {
  group('AchievementBadge.fromRows', () {
    test(
      'assignment makes it earned with full progress and the award date',
      () {
        final badge = AchievementBadge.fromRows(
          _badgeRow(),
          assignment: {'badge_id': 'b1', 'awarded_at': '2026-04-10T08:00:00Z'},
          progressCount: 2,
        );

        expect(badge.isEarned, isTrue);
        expect(badge.currentCount, 7);
        expect(badge.progressFraction, 1);
        expect(badge.earnedAt, DateTime.utc(2026, 4, 10, 8).toLocal());
      },
    );

    test('no assignment is locked and uses badge_progress', () {
      final badge = AchievementBadge.fromRows(_badgeRow(), progressCount: 2);

      expect(badge.isLocked, isTrue);
      expect(badge.currentCount, 2);
      expect(badge.remainingCount, 5);
      expect(badge.earnedAt, isNull);
    });

    test('progress is clamped to 0..target', () {
      expect(
        AchievementBadge.fromRows(_badgeRow(), progressCount: 99).currentCount,
        7,
      );
      expect(
        AchievementBadge.fromRows(_badgeRow(), progressCount: -3).currentCount,
        0,
      );
    });

    test('pre-migration row (no 006 columns) gets safe defaults', () {
      final badge = AchievementBadge.fromRows({
        'id': 'b1',
        'title': 'Contributor',
        'description': 'Became a contributor',
        'icon_url': null,
      });

      expect(badge.category, AchievementBadge.defaultCategory);
      expect(badge.targetCount, 1);
      expect(badge.sortOrder, 0);
      expect(badge.progressUnit, isEmpty);
      expect(badge.progressFraction, 0);
    });

    test('blank category falls back and target < 1 becomes 1', () {
      final badge = AchievementBadge.fromRows(
        _badgeRow(category: '  ', targetCount: 0),
      );

      expect(badge.category, AchievementBadge.defaultCategory);
      expect(badge.targetCount, 1);
    });

    test('earned with missing/invalid awarded_at has no date', () {
      final badge = AchievementBadge.fromRows(
        _badgeRow(),
        assignment: {'badge_id': 'b1', 'awarded_at': null},
      );

      expect(badge.isEarned, isTrue);
      expect(badge.earnedAt, isNull);
    });

    test('only http(s) icon URLs are kept', () {
      expect(
        AchievementBadge.fromRows(
          _badgeRow(iconUrl: 'https://cdn.example.com/b.png'),
        ).iconUrl,
        'https://cdn.example.com/b.png',
      );
      expect(AchievementBadge.fromRows(_badgeRow(iconUrl: '')).iconUrl, isNull);
      expect(
        AchievementBadge.fromRows(_badgeRow(iconUrl: 'not a url')).iconUrl,
        isNull,
      );
    });

    test('numeric fields tolerate strings', () {
      final badge = AchievementBadge.fromRows(
        _badgeRow(sortOrder: '3', targetCount: '5'),
      );

      expect(badge.sortOrder, 3);
      expect(badge.targetCount, 5);
    });
  });

  group('BadgeCategory.group', () {
    AchievementBadge badge(
      String id,
      String category,
      int sortOrder, {
      bool earned = false,
    }) => AchievementBadge.fromRows(
      _badgeRow(id: id, title: id, category: category, sortOrder: sortOrder),
      assignment: earned ? {'badge_id': id} : null,
    );

    test('orders categories by lowest sort_order and badges inside them', () {
      final categories = BadgeCategory.group([
        badge('Contest Participant', 'Participation', 21),
        badge('3-Day Streak', 'Daily Practice', 11, earned: true),
        badge('First Event', 'Participation', 20, earned: true),
        badge('First Solve', 'Daily Practice', 10, earned: true),
        badge('7-Day Streak', 'Daily Practice', 12),
      ]);

      expect(categories.map((c) => c.name), [
        'Daily Practice',
        'Participation',
      ]);
      expect(categories.first.badges.map((b) => b.id), [
        'First Solve',
        '3-Day Streak',
        '7-Day Streak',
      ]);
      expect(categories.first.earnedCount, 2);
      expect(categories.first.totalCount, 3);
      expect(categories.last.earnedCount, 1);
      expect(categories.last.totalCount, 2);
    });

    test('ties fall back to name / title', () {
      final categories = BadgeCategory.group([
        badge('b', 'Zeta', 0),
        badge('a', 'Alpha', 0),
        badge('c', 'Alpha', 0),
      ]);

      expect(categories.map((c) => c.name), ['Alpha', 'Zeta']);
      expect(categories.first.badges.map((b) => b.id), ['a', 'c']);
    });

    test('no badges gives no categories', () {
      expect(BadgeCategory.group(const []), isEmpty);
    });
  });
}
