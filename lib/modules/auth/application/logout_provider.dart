import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/auth_service.dart';
import '../data/services/user_service.dart';
import 'auth_provider.dart';

final userServiceProvider = Provider<UserService>((ref) {
  return UserService();
});

final logoutControllerProvider = AsyncNotifierProvider<LogoutController, void>(
  LogoutController.new,
);

class LogoutController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> logout() async {
    state = const AsyncValue.loading();
    try {
      print('🔐 [LogoutController] Starting logout...');

      final authService = ref.read(authServiceProvider);
      final userService = ref.read(userServiceProvider);

      // Step 1: Update logout timestamp in database
      print('📝 [LogoutController] Updating logout timestamp...');
      await userService.logout();

      // Step 2: Clear user data
      print('🗑️  [LogoutController] Clearing user data...');
      await userService.clearUserData();

      // Step 3: Sign out from Supabase
      print('🔓 [LogoutController] Signing out from Supabase...');
      await authService.signOut();

      // Step 4: Invalidate all providers
      print('♻️  [LogoutController] Invalidating providers...');
      ref.invalidate(authServiceProvider);
      ref.invalidate(userServiceProvider);

      state = const AsyncValue.data(null);
      print('✅ [LogoutController] Logout successful');
      return true;
    } catch (e, st) {
      print('❌ [LogoutController] Logout error: $e');
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}
