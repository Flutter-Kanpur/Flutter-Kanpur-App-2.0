import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_knp_mobile_app_v2/modules/shorebird/playground_demo_content.dart';
import 'package:flutter_knp_mobile_app_v2/modules/shorebird/shorebird_playground_screen.dart';

void main() {
  testWidgets('playground renders and reports updater unavailable', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (_, _) => const MaterialApp(home: ShorebirdPlaygroundScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Shorebird Playground'), findsOneWidget);
    expect(find.text(PlaygroundDemoContent.headline), findsOneWidget);
    expect(find.text('Updater off'), findsOneWidget);
    expect(find.text('None (base release)'), findsOneWidget);

    // Tapping check in a non-Shorebird build logs instead of throwing.
    await tester.tap(find.text('Check for update'));
    await tester.pumpAndSettle();
    expect(find.textContaining('not a Shorebird release build'), findsWidgets);
  });
}
