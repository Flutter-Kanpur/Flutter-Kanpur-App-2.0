import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/modules/leaderboard/application/leaderboard_providers.dart';
import 'package:flutter_knp_mobile_app_v2/modules/leaderboard/domain/leaderboard_models.dart';
import 'package:flutter_knp_mobile_app_v2/modules/leaderboard/presentation/screens/leaderboard_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

LeaderboardEntry _entry(String id, String name, int rank, int points) =>
    LeaderboardEntry(userId: id, name: name, rank: rank, points: points);

final _board = Leaderboard(
  snapshotId: 's1',
  entries: Leaderboard.sorted([
    _entry('u1', 'Angie Rao', 1, 250),
    _entry('u2', 'Akash', 2, 80),
    _entry('u3', 'Naman', 3, 60),
    _entry('u4', 'Pushti Sonawala', 4, 55),
    _entry('me', 'Aneesh Hegde', 5, 1),
  ]),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  // One testWidgets on purpose: EasyLocalization loads its JSON once per test
  // file. Scenarios are switched by swapping [load] and invalidating.
  testWidgets('Leaderboard: podium, list, you, empty, error + retry', (
    tester,
  ) async {
    final previousOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.exceptionAsString().contains('overflowed')) return;
      previousOnError?.call(details);
    };
    addTearDown(() => FlutterError.onError = previousOnError);
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.reset);

    var calls = 0;
    Future<Leaderboard> Function() load = () async => _board;

    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => const LeaderboardScreen()),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          leaderboardProvider.overrideWith((ref) {
            calls++;
            return load();
          }),
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

    Future<void> reload(Future<Leaderboard> Function() next) async {
      load = next;
      ProviderScope.containerOf(
        tester.element(find.byType(LeaderboardScreen)),
      ).invalidate(leaderboardProvider);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
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
    expect(find.text('Share with friends'), findsOneWidget);

    // ── Only a podium (no list card) still renders ──
    await reload(
      () async => Leaderboard(entries: [_entry('u1', 'Angie Rao', 1, 250)]),
    );
    expect(find.text('Angie'), findsOneWidget);
    expect(find.text('Pushti Sonawala'), findsNothing);

    // ── Empty ──
    await reload(() async => Leaderboard.empty);
    expect(find.text('No rankings yet'), findsOneWidget);

    // ── Error, then retry ──
    await reload(() async => throw Exception('offline'));
    expect(find.text("Couldn't load the leaderboard."), findsOneWidget);
    final before = calls;
    load = () async => _board;
    await tester.tap(find.text('Try again'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(calls, before + 1);
    expect(find.text('Angie'), findsOneWidget);
  });
}
