const shortWeekdayAbbreviations = [
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
  'Sun',
];
const shortMonthAbbreviations = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// Plain (non-localized) weekday/month abbreviations — for feature areas
/// that don't localize their copy yet (e.g. My Events/My Contests), unlike
/// LocalizedDateExtensions in date_extensions.dart which does via .tr().
extension ShortDateFormat on DateTime {
  String get shortWeekday => shortWeekdayAbbreviations[weekday - 1];
  String get shortMonth => shortMonthAbbreviations[month - 1];
}
