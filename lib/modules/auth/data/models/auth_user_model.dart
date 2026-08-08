import 'package:flutter_knp_mobile_app_v2/modules/auth/auth_constants.dart';
import 'package:flutter_knp_mobile_app_v2/modules/auth/domain/entities/auth_user.dart';

class AuthUserModel extends AuthUser {
  const AuthUserModel({
    required super.id,
    required super.email,
    required super.username,
    super.displayName,
    super.photoUrl,
    required super.isEmailVerified,
    super.isNewUser,
  });

  factory AuthUserModel.fromMap(Map<String, dynamic> map) {
    return AuthUserModel(
      id: map[AuthConstants.uidField] as String? ?? '',
      email: map[AuthConstants.emailField] as String? ?? '',
      username: map[AuthConstants.usernameField] as String? ?? '',
      displayName: map[AuthConstants.displayNameField] as String?,
      photoUrl: map[AuthConstants.photoUrlField] as String?,
      isEmailVerified: map[AuthConstants.emailVerifiedField] as bool? ?? false,
    );
  }

  // Only columns that actually exist in public.users
  static Map<String, dynamic> toInsertMap({
    required String uid,
    required String email,
    required String username,
    required bool isEmailVerified,
  }) {
    return {
      AuthConstants.uidField: uid,
      AuthConstants.emailField: email,
      AuthConstants.usernameField: username.toLowerCase().trim(),
      AuthConstants.emailVerifiedField: isEmailVerified,
    };
  }
}
