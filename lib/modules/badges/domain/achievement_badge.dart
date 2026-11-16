import 'package:equatable/equatable.dart';

/// One badge as the current user sees it: the `badges` definition merged with
/// their `badge_assignments` row (earned) and `badge_progress` row (locked).
class AchievementBadge extends Equatable {
  const AchievementBadge({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.sortOrder,
    required this.targetCount,
    required this.currentCount,
    this.iconUrl,
    this.progressUnit = '',
    this.howToEarn = '',
    this.earnedMessage = '',
    this.isEarned = false,
    this.earnedAt,
  });

  static const defaultCategory = 'General';

  final String id;
  final String title;
  final String description;
  final String? iconUrl;
  final String category;
  final int sortOrder;

  /// Steps needed to earn the badge, always >= 1.
  final int targetCount;

  /// Steps done so far, clamped to `0..targetCount`.
  final int currentCount;

  /// e.g. "days" in "Progress : 2/3 days". Empty when there's no unit.
  final String progressUnit;

  /// Shown on the locked detail, e.g. "Solve daily problems for 7 days".
  final String howToEarn;

  /// Footer on the earned detail.
  final String earnedMessage;

  final bool isEarned;

  /// Null when earned but the assignment has no timestamp.
  final DateTime? earnedAt;

  bool get isLocked => !isEarned;

  /// 0.0 - 1.0, for the locked-badge progress bar.
  double get progressFraction => currentCount / targetCount;

  int get remainingCount => targetCount - currentCount;

  /// Builds a badge from a `badges` row. Columns added in migration 006
  /// (`category`, `target_count`, ...) are optional so the screen still works
  /// against a database that hasn't been migrated yet.
  factory AchievementBadge.fromRows(
    Map<String, dynamic> badge, {
    Map<String, dynamic>? assignment,
    int? progressCount,
  }) {
    final target = _int(badge['target_count'], fallback: 1).clamp(1, 1 << 30);
    final isEarned = assignment != null;
    final current = isEarned
        ? target
        : _int(progressCount, fallback: 0).clamp(0, target);

    return AchievementBadge(
      id: '${badge['id'] ?? ''}',
      title: _text(badge['title']),
      description: _text(badge['description']),
      iconUrl: _url(badge['icon_url']),
      category: _text(badge['category']).isEmpty
          ? defaultCategory
          : _text(badge['category']),
      sortOrder: _int(badge['sort_order'], fallback: 0),
      targetCount: target,
      currentCount: current,
      progressUnit: _text(badge['progress_unit']),
      howToEarn: _text(badge['how_to_earn']),
      earnedMessage: _text(badge['earned_message']),
      isEarned: isEarned,
      earnedAt: isEarned
          ? DateTime.tryParse('${assignment['awarded_at'] ?? ''}')?.toLocal()
          : null,
    );
  }

  static String _text(dynamic value) => value == null ? '' : '$value'.trim();

  static int _int(dynamic value, {required int fallback}) {
    if (value is num) return value.toInt();
    return int.tryParse('${value ?? ''}') ?? fallback;
  }

  /// Only http(s) URLs are loadable; anything else falls back to the default art.
  static String? _url(dynamic value) {
    final url = _text(value);
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme || !uri.scheme.startsWith('http')) {
      return null;
    }
    return url;
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    iconUrl,
    category,
    sortOrder,
    targetCount,
    currentCount,
    progressUnit,
    howToEarn,
    earnedMessage,
    isEarned,
    earnedAt,
  ];
}

/// A section on the Your Badges screen, e.g. "Daily Practice 2/5".
class BadgeCategory extends Equatable {
  const BadgeCategory({required this.name, required this.badges});

  final String name;
  final List<AchievementBadge> badges;

  int get earnedCount => badges.where((b) => b.isEarned).length;
  int get totalCount => badges.length;

  /// Groups badges by category. Categories are ordered by their lowest
  /// `sort_order` (then name); badges inside by `sort_order` (then title).
  static List<BadgeCategory> group(Iterable<AchievementBadge> badges) {
    final byName = <String, List<AchievementBadge>>{};
    for (final badge in badges) {
      byName.putIfAbsent(badge.category, () => []).add(badge);
    }

    int byOrderThenTitle(AchievementBadge a, AchievementBadge b) {
      final order = a.sortOrder.compareTo(b.sortOrder);
      return order != 0
          ? order
          : a.title.toLowerCase().compareTo(b.title.toLowerCase());
    }

    final categories = [
      for (final entry in byName.entries)
        BadgeCategory(
          name: entry.key,
          badges: [...entry.value]..sort(byOrderThenTitle),
        ),
    ];

    categories.sort((a, b) {
      final order = a.badges.first.sortOrder.compareTo(
        b.badges.first.sortOrder,
      );
      return order != 0
          ? order
          : a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    return categories;
  }

  @override
  List<Object?> get props => [name, badges];
}
