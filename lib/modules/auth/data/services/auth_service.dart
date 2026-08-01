import 'package:flutter_knp_mobile_app_v2/modules/blogs/data/readme_auth_bridge.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/auth_models.dart' as models;

class AuthService {
  final SupabaseClient _client;

  AuthService({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  // ─── Sign In ──────────────────────────────────────────────────────────────

  Future<models.AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      print('🔐 [AuthService] Signing in user: $email');

      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        print('❌ [AuthService] Sign in failed: No user returned');
        return models.AuthResponse.error(
          errorCode: 'NO_USER',
          errorMessage: 'Sign in failed. Please try again.',
        );
      }

      print('✅ [AuthService] Sign in successful: ${user.id}');
      return models.AuthResponse.success(
        userId: user.id,
        email: user.email ?? '',
        message: 'Signed in successfully',
      );
    } on AuthException catch (e) {
      print('❌ [AuthService] Auth error: ${e.message}');
      return models.AuthResponse.error(
        errorCode: e.statusCode ?? 'AUTH_ERROR',
        errorMessage: _mapAuthError(e.message),
      );
    } catch (e) {
      print('❌ [AuthService] Unexpected error: $e');
      return models.AuthResponse.error(
        errorCode: 'UNKNOWN_ERROR',
        errorMessage: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  // ─── Sign Up ──────────────────────────────────────────────────────────────

  Future<models.SignUpResponse> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      print('🔐 [AuthService] Signing up user: $email');

      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        print('❌ [AuthService] Sign up failed: No user returned');
        return models.SignUpResponse.error(
          errorCode: 'NO_USER',
          errorMessage: 'Sign up failed. Please try again.',
        );
      }

      print('✅ [AuthService] Sign up successful: ${user.id}');

      return models.SignUpResponse.success(
        userId: user.id,
        email: user.email ?? '',
        message: 'Account created successfully',
      );
    } on AuthException catch (e) {
      print('❌ [AuthService] Auth error: ${e.message}');
      return models.SignUpResponse.error(
        errorCode: e.statusCode ?? 'AUTH_ERROR',
        errorMessage: _mapAuthError(e.message),
      );
    } catch (e) {
      print('❌ [AuthService] Unexpected error: $e');
      return models.SignUpResponse.error(
        errorCode: 'UNKNOWN_ERROR',
        errorMessage: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  // ─── Sign Out ─────────────────────────────────────────────────────────────

  Future<void> signOut() async {
    try {
      print('🔐 [AuthService] Signing out');
      await _client.auth.signOut();
      await ReadmeAuthBridge.signOut();
      print('✅ [AuthService] Sign out successful');
    } catch (e) {
      print('❌ [AuthService] Sign out error: $e');
      rethrow;
    }
  }

  // ─── Get Current User ─────────────────────────────────────────────────────

  User? getCurrentUser() {
    final user = _client.auth.currentUser;
    print('👤 [AuthService] Current user: ${user?.id}');
    return user;
  }

  // ─── Is Authenticated ─────────────────────────────────────────────────────

  bool isAuthenticated() {
    final isAuth = _client.auth.currentUser != null;
    print('🔐 [AuthService] Is authenticated: $isAuth');
    return isAuth;
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  String _mapAuthError(String? message) {
    if (message == null) return 'An error occurred. Please try again.';

    if (message.toLowerCase().contains('invalid login credentials')) {
      return 'Invalid email or password';
    }
    if (message.toLowerCase().contains('email not confirmed')) {
      return 'Please confirm your email first';
    }
    if (message.toLowerCase().contains('already registered')) {
      return 'This email is already registered';
    }
    if (message.toLowerCase().contains('password')) {
      return 'Password must be at least 6 characters';
    }
    if (message.toLowerCase().contains('email')) {
      return 'Please enter a valid email address';
    }

    return message;
  }
}
