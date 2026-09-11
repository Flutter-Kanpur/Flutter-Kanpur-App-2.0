import 'dart:async';

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

      // Clear any previous session so account switches are clean.
      // Local scope is enough; do not block login on ReadMe cleanup.
      if (_client.auth.currentSession != null) {
        try {
          await _client.auth.signOut(scope: SignOutScope.local);
        } catch (_) {}
        unawaited(ReadmeAuthBridge.signOut());
      }

      final response = await _client.auth.signInWithPassword(
        email: email.trim(),
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

      try {
        await _client.from('users').update({
          'last_login_at': DateTime.now().toIso8601String(),
        }).eq('uid', user.id);
      } catch (_) {
        // profile row may not exist yet — don't block login
      }

      // ReadMe sync must never block Kanpur login (network / edge function hang).
      unawaited(ReadmeAuthBridge.ensureSignedIn(force: true));

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
        errorMessage: _mapNetworkOrUnknownError(e),
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
  data: {
    if (displayName != null && displayName.isNotEmpty)
      'display_name': displayName,
  },
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
      try {
  await _client.from('users').insert({
    'uid': user.id,
    'email': email,
    'username': displayName ?? '',
    'display_name': displayName,
    'email_verified': user.emailConfirmedAt != null,
    'onboarding_completed': false,
  });
} catch (_) {
  // row may already exist from a partial retry
}

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
      await _client.auth.signOut(scope: SignOutScope.global);
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

  String _mapNetworkOrUnknownError(Object error) {
    final text = error.toString().toLowerCase();
    if (text.contains('failed host lookup') ||
        text.contains('socketexception') ||
        text.contains('network is unreachable') ||
        text.contains('connection failed') ||
        text.contains('clientexception')) {
      return 'No internet connection. Check Wi‑Fi/mobile data and try again.';
    }
    return 'An unexpected error occurred. Please try again.';
  }

  String _mapAuthError(String? message) {
    if (message == null) return 'An error occurred. Please try again.';

    final lower = message.toLowerCase();

    if (lower.contains('failed host lookup') ||
        lower.contains('socketexception') ||
        lower.contains('clientexception') ||
        lower.contains('network is unreachable')) {
      return 'No internet / DNS on this device. Restart the emulator with DNS (8.8.8.8) or try a real phone.';
    }

    if (lower.contains('invalid login credentials') ||
        lower.contains('invalid email or password') ||
        lower == 'invalid password') {
      return 'Invalid email or password';
    }
    if (lower.contains('email not confirmed')) {
      return 'Please confirm your email first';
    }
    if (lower.contains('already registered')) {
      return 'This email is already registered';
    }
    // Only map real length/strength errors — not every message that says "password".
    if (lower.contains('password should be at least') ||
        lower.contains('password must be at least') ||
        lower.contains('password is too short') ||
        (lower.contains('password') &&
            (lower.contains('at least 6') || lower.contains('minimum')))) {
      return 'Password must be at least 6 characters';
    }
    if (lower.contains('unable to validate email') ||
        lower.contains('invalid email')) {
      return 'Please enter a valid email address';
    }

    return message;
  }
}
