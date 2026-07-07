import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/auth_service.dart';
import '../domain/auth_models.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Sign In Controller
final signInControllerProvider = AsyncNotifierProvider<SignInController, void>(
  SignInController.new,
);

class SignInController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      final response = await ref.read(authServiceProvider).signIn(
            email: email,
            password: password,
          );
      if (response.success) {
        state = const AsyncValue.data(null);
      }
      return response;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return AuthResponse.error(
        errorCode: 'UNKNOWN_ERROR',
        errorMessage: e.toString(),
      );
    }
  }
}

// Sign Up Controller
final signUpControllerProvider = AsyncNotifierProvider<SignUpController, void>(
  SignUpController.new,
);

class SignUpController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<SignUpResponse> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    state = const AsyncValue.loading();
    try {
      final response = await ref.read(authServiceProvider).signUp(
            email: email,
            password: password,
            displayName: displayName,
          );
      if (response.success) {
        state = const AsyncValue.data(null);
      }
      return response;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return SignUpResponse.error(
        errorCode: 'UNKNOWN_ERROR',
        errorMessage: e.toString(),
      );
    }
  }
}

// Current User
final currentUserProvider = FutureProvider<bool>((ref) async {
  final authService = ref.watch(authServiceProvider);
  return authService.isAuthenticated();
});
