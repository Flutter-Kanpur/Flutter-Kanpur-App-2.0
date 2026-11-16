import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/modules/leaderboard/application/leaderboard_providers.dart';
import 'package:flutter_knp_mobile_app_v2/modules/leaderboard/data/repositories/leaderboard_repository.dart';
import 'package:flutter_knp_mobile_app_v2/modules/leaderboard/domain/leaderboard_models.dart';
import 'package:flutter_knp_mobile_app_v2/modules/leaderboard/presentation/screens/leaderboard_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

LeaderboardEntry _entry(String id, String name, int rank, int points) =>
    LeaderboardEntry(userId: id, name: name, rank: rank, points: points);

final _smallBoard = [
  _entry('u1', 'Angie Rao', 1, 250),
  _entry('u2', 'Akash', 2, 80),
  _entry('u3', 'Naman', 3, 60),
  _entry('u4', 'Pushti Sonawala', 4, 55),
  _entry('me', 'Aneesh Hegde', 5, 1),
];

/// 45 rows = pages of 20 + 20 + 5.
final _bigBoard = [
  for (var i = 1; i <= 45; i++) _entry('u$i', 'User $i', i, 1000 - i),
];

/// In-memory stand-in for Supabase, so the real [LeaderboardNotifier]'s
/// paging runs against it.
class _FakeLeaderboardRepository implements LeaderboardRepository {
  List<LeaderboardEntry> rows = _smallBoard;
  String? snapshotId = 's1';
  bool failSnapshot = false;
  bool failPages = false;
  final pageOffsets = <int>[];

  @override
  Future<String?> fetchLatestSnapshotId() async {
    if (failSnapshot) throw Exception('offline');
    return snapshotId;
  }

  @override
  Future<LeaderboardPage> fetchEntriesPage({
    required String snapshotId,
    required int offset,
    required int limit,
    required String fallbackName,
  }) async {
    pageOffsets.add(offset);
    if (failPages) throw Exception('offline');
    final end = (offset + limit).clamp(0, rows.length);
    return (entries: rows.sublist(offset, end), hasMore: end < rows.length);
  }

  @override
  Future<MyRank> fetchMyRank(String? userId) async => const MyRank(points: 0);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  // One testWidgets on purpose: EasyLocalization loads its JSON once per test
  // file. Scenarios are switched by changing the fake repo and invalidating.
  testWidgets(
    'Leaderboard: podium, list, you, infinite scroll, empty, error + retry',
    (tester) async {
      final previousOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        if (details.exceptionAsString().contains('overflowed')) return;
        previousOnError?.call(details);
      };
      addTearDown(() => FlutterError.onError = previousOnError);
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.75;
      addTearDown(tester.view.reset);

      final repo = _FakeLeaderboardRepository();

      final router = GoRouter(
        routes: [
          GoRoute(path: '/', builder: (_, _) => const LeaderboardScreen()),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            leaderboardRepositoryProvider.overrideWithValue(repo),
            currentUserIdProvider.overrideWith((ref) async => 'me'),
          ],
          child: EasyLocalization(
            supportedLocales: const [Locale('en')],
            path: 'assets/translations',
            fallbackLocale: const Locale('en'),
            child: Builder(
              builder: (context) => ScreenUtilInit(
                designSize: const Size(393, 852),
                builder: (_, _) => MaterialApp.router(
                  routerConfig: router,
                  locale: context.locale,
                  supportedLocales: context.supportedLocales,
                  localizationsDelegates: context.localizationDelegates,
                ),
              ),
            ),
          ),
        ),
      );
      for (var i = 0; i < 50; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 50)),
        );
        await tester.pump();
        if (find.text('Angie').evaluate().isNotEmpty) break;
      }
      await tester.pumpAndSettle();

      final scrollable = find.byType(Scrollable).first;

      Future<void> reload() async {
        ProviderScope.containerOf(
          tester.element(find.byType(LeaderboardScreen)),
        ).invalidate(leaderboardProvider);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        tester.state<ScrollableState>(scrollable).position.jumpTo(0);
        await tester.pump();
      }

      // ── Podium: first names + points ──
      expect(find.text('Leaderboard'), findsOneWidget);
      expect(find.text('Angie'), findsOneWidget);
      expect(find.text('250'), findsOneWidget);
      expect(find.text('Akash'), findsOneWidget);
      expect(find.text('80'), findsOneWidget);
      expect(find.text('Naman'), findsOneWidget);
      expect(find.text('60'), findsOneWidget);

      // ── List from rank 4, own row marked, singular "point" ──
      expect(find.text('4'), findsOneWidget);
      expect(find.text('Pushti Sonawala'), findsOneWidget);
      expect(find.text('55 points'), findsOneWidget);
      expect(find.text('Aneesh Hegde (You)'), findsOneWidget);
      expect(find.text('1 point'), findsOneWidget);
      // Single page, so the share button is shown straight away.
      expect(find.text('Share with friends'), findsOneWidget);

      // ── Infinite scroll: next pages load near the bottom ──
      repo.rows = _bigBoard;
      repo.pageOffsets.clear();
      await reload();
      expect(repo.pageOffsets, [0]);
      expect(find.text('Share with friends'), findsNothing);

      await tester.scrollUntilVisible(
        find.text('User 45'),
        300,
        scrollable: scrollable,
      );
      await tester.pump();
      expect(repo.pageOffsets, [0, 20, 40]);
      await tester.scrollUntilVisible(
        find.text('Share with friends'),
        300,
        scrollable: scrollable,
      );
      expect(find.text('Share with friends'), findsOneWidget);

      // ── A failed later page keeps rows and retries inline ──
      repo.failPages = false;
      repo.pageOffsets.clear();
      await reload();
      repo.failPages = true;
      await tester.scrollUntilVisible(
        find.text("Couldn't load more rankings."),
        300,
        scrollable: scrollable,
      );
      expect(find.text('User 20'), findsOneWidget);
      // Still failing here: scrolling to the button re-triggers loadMore.
      await tester.ensureVisible(find.text('Try again'));
      await tester.pump();
      repo.failPages = false;
      await tester.tap(find.text('Try again'));
      await tester.pump();
      await tester.pump();
      expect(find.text("Couldn't load more rankings."), findsNothing);
      expect(repo.pageOffsets.last, 20);
      await tester.scrollUntilVisible(
        find.text('User 21'),
        300,
        scrollable: scrollable,
      );

      // ── Only a podium (no list card) still renders ──
      repo.rows = [_entry('u1', 'Angie Rao', 1, 250)];
      await reload();
      expect(find.text('Angie'), findsOneWidget);
      expect(find.text('Pushti Sonawala'), findsNothing);

      // ── Empty: no snapshot published ──
      repo.snapshotId = null;
      await reload();
      expect(find.text('No rankings yet'), findsOneWidget);

      // ── First-page error, then retry ──
      repo
        ..snapshotId = 's1'
        ..rows = _smallBoard
        ..failSnapshot = true;
      await reload();
      expect(find.text("Couldn't load the leaderboard."), findsOneWidget);
      repo.failSnapshot = false;
      await tester.tap(find.text('Try again'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Angie'), findsOneWidget);
    },
  );
}
