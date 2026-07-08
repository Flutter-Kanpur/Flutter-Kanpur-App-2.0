enum MyEventCategory { upcoming, past, missed }

enum MyEventsTab { upcoming, past, missed, saved }

extension MyEventsTabX on MyEventsTab {
  String get label => switch (this) {
        MyEventsTab.upcoming => 'Upcoming',
        MyEventsTab.past => 'Past',
        MyEventsTab.missed => 'Missed',
        MyEventsTab.saved => 'Saved',
      };
}

class MyEvent {
  const MyEvent({
    required this.id,
    required this.title,
    required this.dateTimeLocation,
    required this.description,
    required this.statusLabel,
    required this.category,
    this.isSaved = false,
  });

  final String id;
  final String title;
  final String dateTimeLocation;
  final String description;
  final String statusLabel;
  final MyEventCategory category;
  final bool isSaved;

  MyEvent copyWith({bool? isSaved}) {
    return MyEvent(
      id: id,
      title: title,
      dateTimeLocation: dateTimeLocation,
      description: description,
      statusLabel: statusLabel,
      category: category,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
