import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'my_contests_state.dart';

// Temporary mock data - remove when backend is integrated
// startDate/endDate are relative to DateTime.now() at app-start rather than
// fixed calendar dates, so category/metaValue always look "live" no matter
// when this actually runs, instead of going stale after a hardcoded date passes.
List<MyContest> _mockContests() {
  final now = DateTime.now();
  return [
    MyContest(
      id: 'con-1',
      categoryLabel: 'DSA Challenge',
      title: 'Weekly DSA coding sprint',
      tags: const ['Beginner', 'Online', 'DSA'],
      startDate: now.subtract(const Duration(days: 2)),
      endDate: now.add(const Duration(days: 6, hours: 12, minutes: 54)),
      whatYoullDo: const [
        'Solve 5 curated DSA problems',
        'Submit solutions within the time window',
        'Track progress and earn badges',
      ],
      rewardsAndOutcomes: const [
        'Participation badge',
        'Counts toward your activity history',
        'Helps build consistency',
      ],
      isSaved: true,
    ),
    MyContest(
      id: 'con-2',
      categoryLabel: 'DSA Challenge',
      title: 'Weekly DSA coding sprint',
      tags: const ['Beginner', 'Online', 'DSA'],
      startDate: now.subtract(const Duration(days: 1)),
      endDate: now.add(const Duration(days: 4, hours: 3)),
      whatYoullDo: const [
        'Solve 5 curated DSA problems',
        'Submit solutions within the time window',
        'Track progress and earn badges',
      ],
      rewardsAndOutcomes: const [
        'Participation badge',
        'Counts toward your activity history',
        'Helps build consistency',
      ],
    ),
    MyContest(
      id: 'con-3',
      categoryLabel: 'Web Dev Challenge',
      title: 'Build a Portfolio Site',
      tags: const ['Intermediate', 'Online', 'Web'],
      startDate: now.add(const Duration(days: 2, hours: 3)),
      endDate: now.add(const Duration(days: 9)),
      whatYoullDo: const [
        'Design and build a personal portfolio site',
        'Deploy it to a public URL',
        'Submit the link before the deadline',
      ],
      rewardsAndOutcomes: const [
        'Participation badge',
        'Feedback from mentors',
        'Featured in the community showcase',
      ],
    ),
    MyContest(
      id: 'con-4',
      categoryLabel: 'Algorithm Sprint',
      title: 'Monthly Algorithm Marathon',
      tags: const ['Advanced', 'Online', 'DSA'],
      startDate: now.subtract(const Duration(days: 40)),
      endDate: now.subtract(const Duration(days: 38)),
      whatYoullDo: const [
        'Solved advanced algorithm problems against the clock',
        'Competed on the live leaderboard',
      ],
      rewardsAndOutcomes: const [
        'Final leaderboard rank',
        'Counts toward your activity history',
      ],
    ),
  ];
}

class MyContestsNotifier extends Notifier<List<MyContest>> {
  @override
  List<MyContest> build() => _mockContests();

  void toggleSaved(String contestId) {
    state = [
      for (final contest in state)
        if (contest.id == contestId)
          contest.copyWith(isSaved: !contest.isSaved)
        else
          contest,
    ];
  }
}

final myContestsProvider =
    NotifierProvider<MyContestsNotifier, List<MyContest>>(
      MyContestsNotifier.new,
    );

class MyContestsSelectedTabNotifier extends Notifier<MyContestsTab> {
  @override
  MyContestsTab build() => MyContestsTab.ongoing;

  void select(MyContestsTab tab) => state = tab;
}

final myContestsSelectedTabProvider =
    NotifierProvider<MyContestsSelectedTabNotifier, MyContestsTab>(
      MyContestsSelectedTabNotifier.new,
    );

/// Ticks once a second so anything watching it rebuilds. `category` and
/// `metaValue` on [MyContest] are computed from `DateTime.now()` when read,
/// not stored — without this, they'd only refresh whenever something
/// unrelated (switching tabs, toggling save) happened to trigger a rebuild.
///
/// `.autoDispose`: the underlying `Stream.periodic` is torn down as soon as
/// nothing is watching it (i.e. once both My Contests screens are left),
/// rather than ticking for the rest of the app's lifetime.
final contestsTickerProvider = StreamProvider.autoDispose<int>((ref) {
  return Stream.periodic(const Duration(seconds: 1), (tick) => tick);
});

/// Contests narrowed to the currently selected tab.
final myContestsFilteredProvider = Provider.autoDispose<List<MyContest>>((ref) {
  ref.watch(contestsTickerProvider);
  final contests = ref.watch(myContestsProvider);
  final tab = ref.watch(myContestsSelectedTabProvider);
  final category = MyContestCategory.values[tab.index];
  return contests.where((contest) => contest.category == category).toList();
});

/// Looks up a single contest by id, for the detail screen. Returns null if
/// the id doesn't match any mock contest (e.g. a stale/bad deep link).
///
/// Returns a fresh `copyWith()` rather than the stored instance directly:
/// MyContest has no custom `==`, so returning the same object reference on
/// every tick would make Riverpod's default identity-equality check treat
/// it as "unchanged" and silently skip notifying the widget — which was
/// exactly why this screen's countdown wasn't updating.
final myContestByIdProvider = Provider.autoDispose.family<MyContest?, String>((
  ref,
  id,
) {
  ref.watch(contestsTickerProvider);
  final contests = ref.watch(myContestsProvider);
  for (final contest in contests) {
    if (contest.id == id) return contest.copyWith();
  }
  return null;
});
