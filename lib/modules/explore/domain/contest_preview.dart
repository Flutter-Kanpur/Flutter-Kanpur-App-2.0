import 'package:flutter_knp_mobile_app_v2/utils/short_date_format.dart';

enum ContestPhase { upcoming, ongoing, ended, unscheduled }

/// Shaped after `public.contests`; currently populated from
/// [ContestsLocalDataSource], not Supabase.
class ContestPreview {
  const ContestPreview({
    required this.id,
    required this.slug,
    required this.title,
    required this.contestType,
    required this.tags,
    this.startAt,
    this.endAt,
  });

  final String id;
  final String slug;
  final String title;

  /// `contests.contest_type`, title-cased via [categoryLabel].
  final String contestType;

  /// `contests.tags` - assumed, not in the given schema.
  final List<String> tags;

  final DateTime? startAt;
  final DateTime? endAt;

  String get categoryLabel => contestType.isEmpty
      ? 'Contest'
      : contestType[0].toUpperCase() + contestType.substring(1);

  /// Derived from [startAt]/[endAt] - never stored, so it can't go stale.
  ContestPhase get phase {
    if (startAt == null || endAt == null) return ContestPhase.unscheduled;
    final now = DateTime.now();
    if (now.isBefore(startAt!)) return ContestPhase.upcoming;
    if (now.isAfter(endAt!)) return ContestPhase.ended;
    return ContestPhase.ongoing;
  }

  bool get metaUrgent =>
      phase == ContestPhase.ongoing || phase == ContestPhase.ended;

  /// Null when [startAt]/[endAt] aren't set - the meta row is hidden.
  String? get metaLabel => switch (phase) {
    ContestPhase.ongoing => 'Ends in',
    ContestPhase.upcoming => 'Starts in',
    ContestPhase.ended => 'Ended on',
    ContestPhase.unscheduled => null,
  };

  String? get metaValue => switch (phase) {
    ContestPhase.ongoing => _formatCountdown(
      endAt!.difference(DateTime.now()),
    ),
    ContestPhase.upcoming => _formatCountdown(
      startAt!.difference(DateTime.now()),
    ),
    ContestPhase.ended => _formatDate(endAt!),
    ContestPhase.unscheduled => null,
  };

  String get actionLabel =>
      phase == ContestPhase.ongoing ? 'Continue contest' : 'View details';

  static String _formatCountdown(Duration remaining) {
    if (remaining.isNegative) return '0d 00:00:00';
    final days = remaining.inDays;
    final hours = remaining.inHours.remainder(24).toString().padLeft(2, '0');
    final minutes = remaining.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    final seconds = remaining.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    return '${days}d $hours:$minutes:$seconds';
  }

  static String _formatDate(DateTime date) =>
      '${date.shortMonth} ${date.day}';
}
