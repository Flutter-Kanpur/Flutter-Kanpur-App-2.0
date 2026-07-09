import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../modules/auth/application/auth_state_manager.dart';
import 'route_names.dart';

// ============================================================================
// ENUM: Navigation Route
// ============================================================================
enum NavigationRoute {
  splash,
  authLanding,
  home,
}

// ============================================================================
// PROVIDER: Determine next route based on auth state (for splash/app startup)
// ============================================================================
final nextRouteProvider = FutureProvider<NavigationRoute>((ref) async {
  try {
    final user = await ref.watch(currentUserProvider.future);
    return user == null ? NavigationRoute.authLanding : NavigationRoute.home;
  } catch (_) {
    return NavigationRoute.authLanding;
  }
});

final splashRouteProvider = FutureProvider<String>((ref) async {
  await Future<void>.delayed(const Duration(seconds: 2));
  final nextRoute = await ref.watch(nextRouteProvider.future);
  return ref.read(routePathProvider(nextRoute));
});

// ============================================================================
// PROVIDER: Get route path from NavigationRoute
// ============================================================================
final routePathProvider = Provider.family<String, NavigationRoute>((ref, route) {
  final routePaths = {
    NavigationRoute.splash: RouteNames.splash,
    NavigationRoute.authLanding: RouteNames.authLanding,
    NavigationRoute.home: RouteNames.home,
  };

  return routePaths[route] ?? RouteNames.splash;
});
