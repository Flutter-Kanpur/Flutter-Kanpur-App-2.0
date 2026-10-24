import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_knp_mobile_app_v2/core/storage/app_prefs.dart';
import 'package:flutter_knp_mobile_app_v2/modules/auth/application/auth_state_manager.dart';
import 'package:flutter_knp_mobile_app_v2/modules/auth/data/services/user_service.dart';
import 'route_names.dart';

enum NavigationRoute { splash, authLanding, authOptions, onboarding, home }

final nextRouteProvider = FutureProvider<NavigationRoute>((ref) async {
  try {
    final user = await ref.watch(currentUserProvider.future);

    if (user != null) {
      final completed = await UserService().isOnboardingCompleted();
      return completed ? NavigationRoute.home : NavigationRoute.onboarding;
    }

    final hasSeenLanding = await AppPrefs.getHasSeenLanding();
    // Logged-out users who have seen the carousel go to Auth Options, where
    // they choose between Google and email, not straight to email sign-in.
    return hasSeenLanding
        ? NavigationRoute.authOptions
        : NavigationRoute.authLanding;
  } catch (_) {
    final hasSeenLanding = await AppPrefs.getHasSeenLanding();
    // Logged-out users who have seen the carousel go to Auth Options, where
    // they choose between Google and email, not straight to email sign-in.
    return hasSeenLanding
        ? NavigationRoute.authOptions
        : NavigationRoute.authLanding;
  }
});

final splashRouteProvider = FutureProvider<String>((ref) async {
  await Future<void>.delayed(const Duration(seconds: 2));
  final nextRoute = await ref.watch(nextRouteProvider.future);
  return ref.read(routePathProvider(nextRoute));
});

final routePathProvider = Provider.family<String, NavigationRoute>((
  ref,
  route,
) {
  final routePaths = {
    NavigationRoute.splash: RouteNames.splash,
    NavigationRoute.authLanding: RouteNames.authLanding,
    NavigationRoute.authOptions: RouteNames.authOptions,
    NavigationRoute.onboarding: RouteNames.onboardingNavigation,
    NavigationRoute.home: RouteNames.home,
  };

  return routePaths[route] ?? RouteNames.splash;
});
