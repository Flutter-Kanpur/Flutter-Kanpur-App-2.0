import 'package:flutter_knp_mobile_app_v2/modules/auth/application/auth_state.dart';
import 'package:flutter_knp_mobile_app_v2/modules/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_knp_mobile_app_v2/modules/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_knp_mobile_app_v2/modules/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

final _authDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(Supabase.instance.client);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.read(_authDataSourceProvider));
});

final authNotifierProvider = NotifierProvider<AuthNotifier, AppAuthState>(
  AuthNotifier.new,
);

class AuthNotifier extends Notifier<AppAuthState> {
  @override
  AppAuthState build() => const AppAuthState();

  AuthRepository get _repository => ref.read(authRepositoryProvider);

  Future<void> initialize() async {
    state = state.copyWith(status: AuthStatus.loading, error: null);
    try {
      final user = _repository.getCurrentUser();
      if (user == null) {
        state = state.copyWith(status: AuthStatus.unauthenticated, error: null);
        return;
      }
      if (user.isEmailVerified) {
        state = state.copyWith(status: AuthStatus.authenticated, user: user, error: null);
      } else {
        state = state.copyWith(
          status: AuthStatus.verificationSent,
          user: user,
          verificationEmail: user.email,
          error: null,
        );
      }
    } catch (_) {
      state = state.copyWith(status: AuthStatus.unauthenticated, error: null);
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);
    try {
      final user = await _repository.signInWithEmail(email: email, password: password);
      state = state.copyWith(status: AuthStatus.authenticated, user: user, error: null);
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, error: _parseError(e));
    }
  }

  Future<void> signUpWithEmail({
    required String username,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);
    try {
      final user = await _repository.signUpWithEmail(
        username: username,
        email: email,
        password: password,
      );
      state = state.copyWith(
        status: AuthStatus.verificationSent,
        user: user,
        verificationEmail: email,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, error: _parseError(e));
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(status: AuthStatus.loading, error: null);
    try {
      final user = await _repository.signInWithGoogle();
      if (user == null) {
        state = state.copyWith(status: AuthStatus.unauthenticated, error: null);
        return;
      }
      state = state.copyWith(status: AuthStatus.authenticated, user: user, error: null);
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, error: _parseError(e));
    }
  }

  Future<void> checkEmailVerified() async {
    state = state.copyWith(status: AuthStatus.loading, error: null);
    try {
      final user = await _repository.refreshAndCheckVerification();
      if (user == null) {
        state = state.copyWith(status: AuthStatus.unauthenticated, error: null);
        return;
      }
      if (user.isEmailVerified) {
        state = state.copyWith(status: AuthStatus.authenticated, user: user, error: null);
      } else {
        state = state.copyWith(
          status: AuthStatus.verificationSent,
          user: user,
          error: 'Email not verified yet. Please check your inbox.',
        );
      }
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, error: _parseError(e));
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = const AppAuthState(status: AuthStatus.unauthenticated);
  }

  void clearError() {
    if (state.status == AuthStatus.error) {
      state = state.copyWith(status: AuthStatus.unauthenticated, error: null);
    }
  }

  String _parseError(Object e) {
    if (e is AuthException) {
      final msg = e.message.toLowerCase();
      if (msg.contains('invalid login credentials') || msg.contains('invalid_grant')) {
        return 'Invalid email or password.';
      }
      if (msg.contains('email not confirmed')) {
        return 'Please verify your email before signing in.';
      }
      if (msg.contains('user already registered')) {
        return 'An account with this email already exists.';
      }
      if (msg.contains('password')) {
        return 'Password must be at least 6 characters.';
      }
      return e.message;
    }
    if (e is UnimplementedError) return e.message ?? 'Not available yet.';
    return 'Something went wrong. Please try again.';
  }
}
