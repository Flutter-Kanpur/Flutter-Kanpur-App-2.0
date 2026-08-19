import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/contest_preview.dart';

/// Sample data, same convention as ExploreLocalDataSource/HomeMockData.
/// start/end are relative to `DateTime.now()` so the countdown never goes
/// stale.
class ContestsLocalDataSource {
  ContestsLocalDataSource._();

  static List<ContestPreview> fetchAll() {
    final now = DateTime.now();
    return [
      ContestPreview(
        id: 'con-1',
        slug: 'weekly-dsa-coding-sprint',
        title: 'Weekly DSA coding sprint',
        contestType: 'DSA Challenge',
        tags: const ['Beginner', 'Online', 'DSA'],
        startAt: now.subtract(const Duration(days: 2)),
        endAt: now.add(const Duration(days: 6, hours: 12, minutes: 54)),
      ),
      ContestPreview(
        id: 'con-2',
        slug: 'flutter-widget-playground',
        title: 'Build a Flutter widget playground',
        contestType: 'Flutter Challenge',
        tags: const ['Intermediate', 'Online', 'Flutter'],
        startAt: now.subtract(const Duration(days: 1)),
        endAt: now.add(const Duration(days: 4, hours: 3, minutes: 20)),
      ),
      ContestPreview(
        id: 'con-3',
        slug: 'redesign-community-app-screen',
        title: 'Redesign a community app screen',
        contestType: 'UI/UX Challenge',
        tags: const ['Beginner', 'Online', 'UI/UX'],
        startAt: now.add(const Duration(days: 2, hours: 3)),
        endAt: now.add(const Duration(days: 9)),
      ),
      ContestPreview(
        id: 'con-4',
        slug: 'build-a-portfolio-site',
        title: 'Build a Portfolio Site',
        contestType: 'Web Dev Challenge',
        tags: const ['Intermediate', 'Online', 'Web'],
        startAt: now.subtract(const Duration(days: 5)),
        endAt: now.add(const Duration(days: 9)),
      ),
      ContestPreview(
        id: 'con-5',
        slug: 'monthly-algorithm-marathon',
        title: 'Monthly Algorithm Marathon',
        contestType: 'Algorithm Sprint',
        tags: const ['Advanced', 'Online', 'DSA'],
        startAt: now.add(const Duration(days: 5, hours: 12)),
        endAt: now.add(const Duration(days: 12)),
      ),
      ContestPreview(
        id: 'con-6',
        slug: 'weekend-dsa-speedrun',
        title: 'Weekend DSA speedrun',
        contestType: 'DSA Challenge',
        tags: const ['Beginner', 'Online', 'DSA'],
        startAt: now.subtract(const Duration(days: 40)),
        endAt: now.subtract(const Duration(days: 38)),
      ),
    ];
  }
}
