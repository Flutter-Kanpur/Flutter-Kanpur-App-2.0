import '../../../utils/short_date_format.dart';

enum MyContestCategory { ongoing, upcoming, past }

enum MyContestsTab { ongoing, upcoming, past }

extension MyContestsTabX on MyContestsTab {
  String get label => switch (this) {
    MyContestsTab.ongoing => 'Ongoing',
    MyContestsTab.upcoming => 'Upcoming',
    MyContestsTab.past => 'Past',
  };
}

/// Color treatment for [MyContest.metaValue]: red for an ongoing contest's
/// countdown or a past one's end date, green for an upcoming one's countdown.
enum MyContestMetaTone { urgent, positive }

class MyContest {
  const MyContest({
    required this.id,
    required this.categoryLabel,
    required this.title,
    required this.tags,
    required this.startDate,
    required this.endDate,
    required this.whatYoullDo,
    required this.rewardsAndOutcomes,
    this.isSaved = false,
  });

  final String id;

  /// e.g. "DSA Challenge" — the contest's type, shown above the title.
  final String categoryLabel;
  final String title;
  final List<String> tags;

  final DateTime startDate;
  final DateTime endDate;

  /// Detail-screen-only bullet lists.
  final List<String> whatYoullDo;
  final List<String> rewardsAndOutcomes;

  final bool isSaved;

  /// Derived from [startDate]/[endDate] against the current time — not
  /// stored, so it can never drift out of sync with the actual schedule.
  MyContestCategory get category {
    final now = DateTime.now();
    if (now.isBefore(startDate)) return MyContestCategory.upcoming;
    if (now.isAfter(endDate)) return MyContestCategory.past;
    return MyContestCategory.ongoing;
  }

  MyContestMetaTone get metaTone => switch (category) {
    MyContestCategory.upcoming => MyContestMetaTone.positive,
    MyContestCategory.ongoing ||
    MyContestCategory.past => MyContestMetaTone.urgent,
  };

  String get metaLabel => switch (category) {
    MyContestCategory.ongoing => 'Ends in',
    MyContestCategory.upcoming => 'Starts in',
    MyContestCategory.past => 'Ended on',
  };

  /// A countdown to start/end for ongoing/upcoming contests, or the end
  /// date for a past one. Computed against `DateTime.now()` whenever this
  /// is read, so it's only ever as fresh as the last rebuild — there's no
  /// periodic timer ticking it every second.
  String get metaValue {
    switch (category) {
      case MyContestCategory.upcoming:
        return _formatCountdown(startDate.difference(DateTime.now()));
      case MyContestCategory.ongoing:
        return _formatCountdown(endDate.difference(DateTime.now()));
      case MyContestCategory.past:
        return _formatDate(endDate);
    }
  }

  String get actionLabel => switch (category) {
    MyContestCategory.ongoing => 'Continue contest',
    MyContestCategory.upcoming || MyContestCategory.past => 'View summary',
  };

  /// Fixed schedule line for the detail screen, e.g. "Sun, 11 Jan, 08:00 IST".
  String get scheduleLabel {
    final hour = startDate.hour.toString().padLeft(2, '0');
    final minute = startDate.minute.toString().padLeft(2, '0');
    return '${startDate.shortWeekday}, ${startDate.day} ${startDate.shortMonth}, '
        '$hour:$minute ${startDate.timeZoneName}';
  }

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

  static String _formatDate(DateTime date) {
    return '${date.shortMonth} ${date.day}';
  }

  MyContest copyWith({bool? isSaved}) {
    return MyContest(
      id: id,
      categoryLabel: categoryLabel,
      title: title,
      tags: tags,
      startDate: startDate,
      endDate: endDate,
      whatYoullDo: whatYoullDo,
      rewardsAndOutcomes: rewardsAndOutcomes,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
