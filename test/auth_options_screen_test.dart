import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/modules/auth/application/auth_state_manager.dart';
import 'package:flutter_knp_mobile_app_v2/modules/auth/presentation/screens/auth_options_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  late int googleCalls;
  var googleFails = false;
  late GoRouter router;

  Future<void> pump(WidgetTester tester) async {
    googleCalls = 0;
    googleFails = false;
    // flutter_test renders with the Ahem font (every glyph is a full-width
    // square), so button labels overflow here but not in ProductSans.
    final previousOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.exceptionAsString().contains('overflowed')) return;
      previousOnError?.call(details);
    };
    addTearDown(() => FlutterError.onError = previousOnError);

    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.reset);

    router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => const AuthOptionsScreen()),
        GoRoute(
          path: RouteNames.signIn,
          builder: (_, _) => const Scaffold(body: Text('SIGN_IN_SCREEN')),
        ),
        GoRoute(
          path: RouteNames.signUp,
          builder: (_, _) => const Scaffold(body: Text('SIGN_UP_SCREEN')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentUserProvider.overrideWith((ref) async => null),
          signInWithGoogleProvider.overrideWithValue(() async {
            googleCalls++;
            if (googleFails) throw Exception('Google is down');
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
    // EasyLocalization reads the translation JSON on a real async task, so
    // wait (in real time) until the screen has rendered.
    for (var i = 0; i < 50; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pump();
      if (find.text('Continue with Google').evaluate().isNotEmpty) break;
    }
    await tester.pumpAndSettle();
  }

  // `push` leaves `uri` on the base route; the visible route is the last match.
  String location() =>
      router.routerDelegate.currentConfiguration.last.matchedLocation;

  testWidgets('each CTA on the auth options screen does its own thing', (
    tester,
  ) async {
    await pump(tester);

    // Continue with Google -> Google auth, no navigation.
    await tester.tap(find.text('Continue with Google'));
    await tester.pumpAndSettle();
    expect(googleCalls, 1);
    expect(location(), '/');
    expect(find.text('SIGN_IN_SCREEN'), findsNothing);

    // Sign in with Email -> email flow, Google not triggered.
    await tester.tap(find.text('Sign in with Email'));
    await tester.pumpAndSettle();
    expect(googleCalls, 1);
    expect(location(), RouteNames.signIn);
    router.pop();
    await tester.pumpAndSettle();

    // Create Account -> sign up, Google not triggered.
    await tester.tap(find.text('Create Account'));
    await tester.pumpAndSettle();
    expect(googleCalls, 1);
    expect(location(), RouteNames.signUp);
    router.pop();
    await tester.pumpAndSettle();

    // A Google failure shows a message and does not navigate.
    googleFails = true;
    await tester.tap(find.text('Continue with Google'));
    await tester.pumpAndSettle();
    expect(googleCalls, 2);
    expect(location(), '/');
    expect(find.text('Google is down'), findsOneWidget);
  });
}
