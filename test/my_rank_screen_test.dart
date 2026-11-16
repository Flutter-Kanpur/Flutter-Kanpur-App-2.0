import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/modules/leaderboard/application/leaderboard_providers.dart';
import 'package:flutter_knp_mobile_app_v2/modules/leaderboard/domain/leaderboard_models.dart';
import 'package:flutter_knp_mobile_app_v2/modules/leaderboard/presentation/screens/my_rank_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  // One testWidgets on purpose - see leaderboard_screen_test.dart.
  testWidgets('My Rank: ranked, top level, unranked, unpublished, error', (
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
    Future<MyRank> Function() load = () async =>
        const MyRank(points: 200, rank: 9);

    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => const MyRankScreen()),
        GoRoute(
          path: RouteNames.leaderboard,
          builder: (_, _) => const Scaffold(body: Text('LEADERBOARD_SCREEN')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          myRankProvider.overrideWith((ref) {
            calls++;
            return load();
          }),
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
      if (find.text('Consistent Learner').evaluate().isNotEmpty) break;
    }
    await tester.pumpAndSettle();

    Future<void> reload(Future<MyRank> Function() next) async {
      load = next;
      ProviderScope.containerOf(
        tester.element(find.byType(MyRankScreen)),
      ).invalidate(myRankProvider);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
    }

    // ── Ranked, mid level ──
    expect(find.text('My Ranks'), findsOneWidget);
    expect(find.text('Consistent Learner'), findsOneWidget);
    expect(find.text('Level 3 of 6'), findsOneWidget);
    expect(find.text('200 points'), findsOneWidget);
    expect(find.text('#9 on leaderboard'), findsOneWidget);
    expect(find.text('100 points more to reach Contributor'), findsOneWidget);
    expect(find.text('Share with friends'), findsOneWidget);
    final bar = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(bar.value, closeTo(50 / 150, 0.001));

    // ── Top level ──
    await reload(() async => const MyRank(points: 1500, rank: 1));
    expect(find.text('Flutter Champion'), findsOneWidget);
    expect(find.text('Level 6 of 6'), findsOneWidget);
    expect(find.text("You've reached the highest level!"), findsOneWidget);

    // ── Not on the leaderboard ──
    await reload(() async => const MyRank(points: 0));
    expect(find.text('Newcomer'), findsOneWidget);
    expect(find.text('Level 1 of 6'), findsOneWidget);
    expect(
      find.textContaining("You're not on the leaderboard yet"),
      findsOneWidget,
    );
    expect(find.textContaining('on leaderboard'), findsNothing);

    // ── Nothing published ──
    await reload(() async => const MyRank(points: 0, hasLeaderboard: false));
    expect(
      find.textContaining("Rankings haven't been published"),
      findsOneWidget,
    );

    // ── Error, then retry ──
    await reload(() async => throw Exception('offline'));
    expect(find.text("Couldn't load your rank."), findsOneWidget);
    final before = calls;
    load = () async => const MyRank(points: 200, rank: 9);
    await tester.tap(find.text('Try again'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(calls, before + 1);
    expect(find.text('Consistent Learner'), findsOneWidget);

    // ── View leaderboard navigates ──
    await tester.ensureVisible(find.text('View leaderboard'));
    await tester.tap(find.text('View leaderboard'));
    await tester.pumpAndSettle();
    expect(find.text('LEADERBOARD_SCREEN'), findsOneWidget);
  });
}
