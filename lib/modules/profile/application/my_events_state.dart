import '../../../utils/short_date_format.dart';

enum MyEventCategory { upcoming, past, missed }

enum MyEventsTab { upcoming, past, missed, saved }

extension MyEventsTabX on MyEventsTab {
  String get label => switch (this) {
        MyEventsTab.upcoming => 'Upcoming',
        MyEventsTab.past => 'Past',
        MyEventsTab.missed => 'Missed',
        MyEventsTab.saved => 'Saved',
      };

  /// Empty-state heading/subheading/CTA when this tab has no events. Each
  /// tab's CTA points at a *different* tab (usually Upcoming) rather than
  /// itself, since suggesting the user browse the empty tab again is useless.
  String get emptyHeading => switch (this) {
        MyEventsTab.upcoming => 'No upcoming events right now',
        MyEventsTab.past => 'No past events yet',
        MyEventsTab.missed => 'No missed events',
        MyEventsTab.saved => 'No saved events yet',
      };

  String get emptySubheading => switch (this) {
        MyEventsTab.upcoming => 'Check back soon for upcoming meetups and sessions.',
        MyEventsTab.past => "Attend an event and it'll show up here afterward.",
        MyEventsTab.missed => "Great — you haven't missed any events you registered for.",
        MyEventsTab.saved => 'Tap the bookmark on an event to save it for later.',
      };

  String get emptyActionLabel => switch (this) {
        MyEventsTab.upcoming => 'Browse past events',
        MyEventsTab.past || MyEventsTab.missed || MyEventsTab.saved => 'Browse upcoming events',
      };

  MyEventsTab get emptyActionTarget => switch (this) {
        MyEventsTab.upcoming => MyEventsTab.past,
        MyEventsTab.past || MyEventsTab.missed || MyEventsTab.saved => MyEventsTab.upcoming,
      };
}

class MyEvent {
  const MyEvent({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.location,
    required this.description,
    required this.attended,
    this.isSaved = false,
  });

  final String id;
  final String title;
  final DateTime dateTime;
  final String location;
  final String description;

  /// Only meaningful once [dateTime] has passed — whether the user actually
  /// attended. Determines whether a past event's category is `past` (attended)
  /// or `missed` (didn't). Irrelevant while the event is still upcoming.
  final bool attended;

  final bool isSaved;

  /// Derived from [dateTime]/[attended] against the current time — not
  /// stored, so it can never drift out of sync (this is what a hand-set
  /// `category` field did on My Contests before that was reworked the same way).
  MyEventCategory get category {
    if (DateTime.now().isBefore(dateTime)) return MyEventCategory.upcoming;
    return attended ? MyEventCategory.past : MyEventCategory.missed;
  }

  String get statusLabel => switch (category) {
        MyEventCategory.upcoming => 'Live',
        MyEventCategory.past => 'Completed',
        MyEventCategory.missed => 'Missed',
      };

  /// e.g. "Sun, 7 Apr • 4:00 PM • Kanpur" — combines [dateTime]/[location]
  /// back into the single display string the card/detail UI expects.
  String get dateTimeLocation {
    final hour12 = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '${dateTime.shortWeekday}, ${dateTime.day} ${dateTime.shortMonth} • '
        '$hour12:$minute $period • $location';
  }

  MyEvent copyWith({bool? isSaved}) {
    return MyEvent(
      id: id,
      title: title,
      dateTime: dateTime,
      location: location,
      description: description,
      attended: attended,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
