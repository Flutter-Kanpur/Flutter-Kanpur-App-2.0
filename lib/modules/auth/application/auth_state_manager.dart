import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/auth_service.dart';
import '../data/services/user_service.dart';

// ============================================================================
// CLASS: User Info Model
// ============================================================================
class UserInfo {
  final String? userId;
  final String? email;
  final String? displayName;

  const UserInfo({this.userId, this.email, this.displayName});

  UserInfo copyWith({String? userId, String? email, String? displayName}) {
    return UserInfo(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
    );
  }
}

// ============================================================================
// PROVIDERS: Services
// ============================================================================
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final userServiceProvider = Provider<UserService>((ref) {
  return UserService();
});

// ============================================================================
// PROVIDER: Current Auth Status
// ============================================================================
final currentUserProvider = FutureProvider<UserInfo?>((ref) async {
  final authService = ref.watch(authServiceProvider);

  try {
    final isAuth = authService.isAuthenticated();
    if (isAuth) {
      final user = authService.getCurrentUser();
      if (user != null) {
        return UserInfo(
          userId: user.id,
          email: user.email,
          displayName: user.userMetadata?['display_name'] as String?,
        );
      }
    }
    return null;
  } catch (e) {
    return null;
  }
});

// ============================================================================
// PROVIDERS: Auth Actions (Sign In, Sign Up, Sign Out)
// ============================================================================

/// Sign in with email and password.
final signInProvider =
    Provider<
      Future<void> Function({required String email, required String password})
    >((ref) {
      return ({required String email, required String password}) async {
        final authService = ref.read(authServiceProvider);

        final response = await authService.signIn(
          email: email,
          password: password,
        );

        if (!response.success) {
          throw Exception(response.errorMessage ?? 'Sign in failed');
        }

        ref.invalidate(currentUserProvider);
      };
    });

/// Sign up with email, password, and display name
final signUpProvider =
    Provider<
      Future<void> Function({
        required String email,
        required String password,
        required String displayName,
      })
    >((ref) {
      return ({
        required String email,
        required String password,
        required String displayName,
      }) async {
        final authService = ref.read(authServiceProvider);

        final response = await authService.signUp(
          email: email,
          password: password,
          displayName: displayName,
        );

        if (!response.success) {
          throw Exception(response.errorMessage ?? 'Sign up failed');
        }

        ref.invalidate(currentUserProvider);
      };
    });

/// Sign out user. This is an action provider, not a cached FutureProvider,
/// so every logout tap executes a fresh sign-out.
final signOutProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    final authService = ref.read(authServiceProvider);
    final userService = ref.read(userServiceProvider);

    await userService.logout();
    await userService.clearUserData();
    await authService.signOut();

    ref.invalidate(currentUserProvider);
  };
});

// ============================================================================
// PROVIDERS: Computed/Derived State
// ============================================================================

/// Check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  return currentUser.maybeWhen(
    data: (user) => user != null,
    orElse: () => false,
  );
});

/// Get current user ID
final currentUserIdProvider = Provider<String?>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  return currentUser.maybeWhen(
    data: (user) => user?.userId,
    orElse: () => null,
  );
});

/// Get current user email
final currentUserEmailProvider = Provider<String?>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  return currentUser.maybeWhen(data: (user) => user?.email, orElse: () => null);
});

/// Get current user display name
final currentUserDisplayNameProvider = Provider<String?>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  return currentUser.maybeWhen(
    data: (user) => user?.displayName,
    orElse: () => null,
  );
});
