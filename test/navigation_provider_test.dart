import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/navigation_provider.dart';
import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/modules/auth/application/auth_state_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<String> splashDestination({required bool hasSeenLanding}) async {
    SharedPreferences.setMockInitialValues({
      'has_seen_landing': hasSeenLanding,
    });
    final container = ProviderContainer(
      overrides: [currentUserProvider.overrideWith((ref) async => null)],
    );
    addTearDown(container.dispose);
    final route = await container.read(nextRouteProvider.future);
    return container.read(routePathProvider(route));
  }

  test(
    'logged-out user who has seen the carousel lands on Auth Options',
    () async {
      expect(
        await splashDestination(hasSeenLanding: true),
        RouteNames.authOptions,
      );
    },
  );

  test('logged-out first-time user sees the landing carousel', () async {
    expect(
      await splashDestination(hasSeenLanding: false),
      RouteNames.authLanding,
    );
  });
}
