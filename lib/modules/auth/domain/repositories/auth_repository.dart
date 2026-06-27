import 'package:flutter_knp_mobile_app_v2/modules/auth/domain/entities/auth_user.dart';

abstract class AuthRepository {
  Future<AuthUser> signInWithEmail({
    required String email,
    required String password,
  });

  Future<AuthUser> signUpWithEmail({
    required String username,
    required String email,
    required String password,
  });

  Future<AuthUser?> signInWithGoogle();

  Future<void> signOut();

  Future<AuthUser?> refreshAndCheckVerification();

  AuthUser? getCurrentUser();
}
