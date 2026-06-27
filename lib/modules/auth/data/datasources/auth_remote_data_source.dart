import 'package:flutter_knp_mobile_app_v2/modules/auth/auth_constants.dart';
import 'package:flutter_knp_mobile_app_v2/modules/auth/data/models/auth_user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._client);

  final SupabaseClient _client;

  Future<AuthUserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) throw const AuthException('Sign in failed.');

    await _client
        .from(AuthConstants.usersTable)
        .update({AuthConstants.lastLoginAtField: DateTime.now().toIso8601String()})
        .eq(AuthConstants.uidField, user.id);

    final rows = await _client
        .from(AuthConstants.usersTable)
        .select()
        .eq(AuthConstants.uidField, user.id);

    if (rows.isEmpty) {
      return AuthUserModel(
        id: user.id,
        email: user.email ?? '',
        username: '',
        isEmailVerified: user.emailConfirmedAt != null,
      );
    }

    return AuthUserModel.fromMap(rows.first);
  }

  Future<AuthUserModel> signUpWithEmail({
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) throw const AuthException('Sign up failed.');

    await _client.from(AuthConstants.usersTable).insert(
      AuthUserModel.toInsertMap(
        uid: user.id,
        email: email,
        username: username,
        isEmailVerified: user.emailConfirmedAt != null,
      ),
    );

    return AuthUserModel(
      id: user.id,
      email: email,
      username: username,
      isEmailVerified: user.emailConfirmedAt != null,
      isNewUser: true,
    );
  }

  // Google sign-in — wire up when google_sign_in v7 native flow is ready
  Future<AuthUserModel?> signInWithGoogle() async {
    throw UnimplementedError('Google sign-in coming soon.');
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<AuthUserModel?> refreshAndCheckVerification() async {
    await _client.auth.refreshSession();
    final user = _client.auth.currentUser;
    if (user == null) return null;

    if (user.emailConfirmedAt != null) {
      await _client
          .from(AuthConstants.usersTable)
          .update({AuthConstants.emailVerifiedField: true})
          .eq(AuthConstants.uidField, user.id);
    }

    final rows = await _client
        .from(AuthConstants.usersTable)
        .select()
        .eq(AuthConstants.uidField, user.id);

    if (rows.isEmpty) {
      return AuthUserModel(
        id: user.id,
        email: user.email ?? '',
        username: '',
        isEmailVerified: user.emailConfirmedAt != null,
      );
    }

    return AuthUserModel.fromMap(rows.first);
  }

  AuthUserModel? getCurrentUser() {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    return AuthUserModel(
      id: user.id,
      email: user.email ?? '',
      username: '',
      isEmailVerified: user.emailConfirmedAt != null,
    );
  }
}
