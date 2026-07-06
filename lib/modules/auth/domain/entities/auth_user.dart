import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  const AuthUser({
    required this.id,
    required this.email,
    required this.username,
    this.displayName,
    this.photoUrl,
    required this.isEmailVerified,
    this.isNewUser = false,
  });

  final String id;
  final String email;
  final String username;
  final String? displayName;
  final String? photoUrl;
  final bool isEmailVerified;
  final bool isNewUser;

  @override
  List<Object?> get props => [id, email, username, isEmailVerified];
}
