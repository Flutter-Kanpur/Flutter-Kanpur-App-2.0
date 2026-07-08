import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'my_events_state.dart';

// Temporary mock data - remove when backend is integrated
// dateTime is relative to DateTime.now() at app-start rather than a fixed
// calendar date, so category (derived from dateTime/attended) always looks
// "live" no matter when this actually runs — same reasoning as My Contests.
List<MyEvent> _mockEvents() {
  final now = DateTime.now();
  return [
    MyEvent(
      id: 'evt-1',
      title: 'From Figma to Flutter: Practical Workflow',
      dateTime: now.add(const Duration(days: 3, hours: 4)),
      location: 'Kanpur',
      description:
          'Learn production-ready Flutter architecture, from Figma handoff to a shipped app.',
      attended: false,
      isSaved: true,
    ),
    MyEvent(
      id: 'evt-2',
      title: 'From Figma to Flutter: Practical Workflow',
      dateTime: now.add(const Duration(days: 5, hours: 4)),
      location: 'Kanpur',
      description:
          'Learn production-ready Flutter architecture, from Figma handoff to a shipped app.',
      attended: false,
    ),
    MyEvent(
      id: 'evt-3',
      title: 'Flutter Kanpur Meetup #12',
      dateTime: now.subtract(const Duration(days: 10)),
      location: 'Kanpur',
      description:
          'A recap of the community meetup covering state management patterns and Q&A.',
      attended: true,
    ),
    MyEvent(
      id: 'evt-4',
      title: 'Intro to Riverpod Workshop',
      dateTime: now.subtract(const Duration(days: 5)),
      location: 'Kanpur',
      description:
          'A hands-on workshop introducing Riverpod for state management in Flutter apps.',
      attended: false,
    ),
  ];
}

class MyEventsNotifier extends Notifier<List<MyEvent>> {
  @override
  List<MyEvent> build() => _mockEvents();

  void toggleSaved(String eventId) {
    state = [
      for (final event in state)
        if (event.id == eventId) event.copyWith(isSaved: !event.isSaved) else event,
    ];
  }
}

final myEventsProvider = NotifierProvider<MyEventsNotifier, List<MyEvent>>(
  MyEventsNotifier.new,
);

class MyEventsSelectedTabNotifier extends Notifier<MyEventsTab> {
  @override
  MyEventsTab build() => MyEventsTab.upcoming;

  void select(MyEventsTab tab) => state = tab;
}

final myEventsSelectedTabProvider =
    NotifierProvider<MyEventsSelectedTabNotifier, MyEventsTab>(
  MyEventsSelectedTabNotifier.new,
);

/// Events narrowed to the currently selected tab.
final myEventsFilteredProvider = Provider<List<MyEvent>>((ref) {
  final events = ref.watch(myEventsProvider);
  final tab = ref.watch(myEventsSelectedTabProvider);

  if (tab == MyEventsTab.saved) {
    return events.where((event) => event.isSaved).toList();
  }
  final category = MyEventCategory.values[tab.index];
  return events.where((event) => event.category == category).toList();
});

/// Per-card "see more" expand/collapse, keyed by event id so each card is independent.
/// Riverpod's non-codegen family API passes the arg via the Notifier's
/// constructor, not via build() — build() always takes zero arguments.
class MyEventCardExpandedNotifier extends Notifier<bool> {
  MyEventCardExpandedNotifier(this.eventId);

  final String eventId;

  @override
  bool build() => false;

  void toggle() => state = !state;
}

final myEventCardExpandedProvider =
    NotifierProvider.family<MyEventCardExpandedNotifier, bool, String>(
  MyEventCardExpandedNotifier.new,
);
