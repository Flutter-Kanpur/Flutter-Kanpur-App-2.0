import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'my_events_state.dart';

// Temporary mock data - remove when backend is integrated
List<MyEvent> _mockEvents() => [
      const MyEvent(
        id: 'evt-1',
        title: 'From Figma to Flutter: Practical Workflow',
        dateTimeLocation: 'Sun, 7 Apr • 4:00 PM • Kanpur',
        description:
            'Learn production-ready Flutter architecture, from Figma handoff to a shipped app.',
        statusLabel: 'Live',
        category: MyEventCategory.upcoming,
        isSaved: true,
      ),
      const MyEvent(
        id: 'evt-2',
        title: 'From Figma to Flutter: Practical Workflow',
        dateTimeLocation: 'Sun, 7 Apr • 4:00 PM • Kanpur',
        description:
            'Learn production-ready Flutter architecture, from Figma handoff to a shipped app.',
        statusLabel: 'Live',
        category: MyEventCategory.upcoming,
      ),
      const MyEvent(
        id: 'evt-3',
        title: 'Flutter Kanpur Meetup #12',
        dateTimeLocation: 'Sun, 2 Mar • 5:00 PM • Kanpur',
        description:
            'A recap of the community meetup covering state management patterns and Q&A.',
        statusLabel: 'Ended',
        category: MyEventCategory.past,
      ),
      const MyEvent(
        id: 'evt-4',
        title: 'Intro to Riverpod Workshop',
        dateTimeLocation: 'Sat, 18 Jan • 11:00 AM • Kanpur',
        description:
            'A hands-on workshop introducing Riverpod for state management in Flutter apps.',
        statusLabel: 'Missed',
        category: MyEventCategory.missed,
      ),
    ];

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
