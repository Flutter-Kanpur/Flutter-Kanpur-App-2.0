import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/modules/badges/application/badges_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/badges/domain/achievement_badge.dart';
import 'package:flutter_knp_mobile_app_v2/modules/badges/presentation/screens/your_badges_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

AchievementBadge _badge(
  String title, {
  required String category,
  required int sortOrder,
  int target = 1,
  int progress = 0,
  bool earned = false,
}) => AchievementBadge.fromRows(
  {
    'id': title,
    'title': title,
    'description': '$title description',
    'category': category,
    'sort_order': sortOrder,
    'target_count': target,
    'progress_unit': target > 1 ? 'days' : '',
    'how_to_earn': 'How to earn $title',
    'earned_message': 'Earned message for $title',
  },
  assignment: earned
      ? {'badge_id': title, 'awarded_at': '2026-04-10T08:00:00Z'}
      : null,
  progressCount: progress,
);

final _sample = BadgeCategory.group([
  _badge('First Solve', category: 'Daily Practice', sortOrder: 1, earned: true),
  _badge(
    '7-Day Streak',
    category: 'Daily Practice',
    sortOrder: 2,
    target: 7,
    progress: 2,
  ),
  _badge('First Event', category: 'Participation', sortOrder: 10),
]);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  // One testWidgets on purpose: EasyLocalization only loads its JSON once per
  // test file, so later tests would render nothing. Scenarios are switched by
  // swapping [load] and invalidating the provider instead.
  testWidgets('Your Badges: data, details, empty, error + retry', (
    tester,
  ) async {
    // Ahem test font is wider than ProductSans; ignore overflow noise.
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
    Future<List<BadgeCategory>> Function() load = () async => _sample;

    final router = GoRouter(
      routes: [GoRoute(path: '/', builder: (_, _) => const YourBadgesScreen())],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          myBadgeCategoriesProvider.overrideWith((ref) {
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
    // EasyLocalization loads JSON on a real async task.
    for (var i = 0; i < 50; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pump();
      if (find.text('Daily Practice').evaluate().isNotEmpty) break;
    }
    await tester.pumpAndSettle();

    Future<void> reload(Future<List<BadgeCategory>> Function() next) async {
      load = next;
      ProviderScope.containerOf(
        tester.element(find.byType(YourBadgesScreen)),
      ).invalidate(myBadgeCategoriesProvider);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
    }

    Future<void> closeDialog() async {
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
    }

    // ── Grouped grid with earned/total counts ──
    expect(find.text('Your Badges'), findsOneWidget);
    expect(find.text('Daily Practice'), findsOneWidget);
    expect(find.text('1/2'), findsOneWidget);
    expect(find.text('Participation'), findsOneWidget);
    expect(find.text('0/1'), findsOneWidget);
    expect(find.text('Earned on Apr 10'), findsOneWidget);
    expect(find.text('Locked'), findsNWidgets(2));

    // ── Earned badge detail ──
    await tester.tap(find.text('First Solve'));
    await tester.pumpAndSettle();
    expect(find.text('Earned on:'), findsOneWidget);
    expect(find.text('Apr 10, 2026'), findsOneWidget);
    expect(find.text('First Solve description'), findsOneWidget);
    expect(find.text('Earned message for First Solve'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsNothing);
    await closeDialog();
    expect(find.text('Earned on:'), findsNothing);

    // ── Locked badge with partial progress ──
    await tester.tap(find.text('7-Day Streak'));
    await tester.pumpAndSettle();
    expect(find.text('How to earn 7-Day Streak'), findsOneWidget);
    expect(find.text('Progress : 2/7 days'), findsOneWidget);
    expect(
      find.text('Keep going. 5 more to unlock this badge.'),
      findsOneWidget,
    );
    final bar = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(bar.value, closeTo(2 / 7, 0.001));
    await closeDialog();

    // ── Locked badge with no progress, no unit ──
    await tester.tap(find.text('First Event'));
    await tester.pumpAndSettle();
    expect(find.text('Progress : 0/1'), findsOneWidget);
    expect(
      find.text('Get started today to make progress toward this badge.'),
      findsOneWidget,
    );
    await closeDialog();

    // ── Empty ──
    await reload(() async => const []);
    expect(find.text('No badges yet'), findsOneWidget);
    expect(find.text('Daily Practice'), findsNothing);

    // ── Error, then retry recovers ──
    await reload(() async => throw Exception('offline'));
    expect(find.text("Couldn't load your badges."), findsOneWidget);

    final callsBeforeRetry = calls;
    load = () async => _sample;
    await tester.tap(find.text('Try again'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(calls, callsBeforeRetry + 1);
    expect(find.text('Daily Practice'), findsOneWidget);
    expect(find.text("Couldn't load your badges."), findsNothing);
  });
}
