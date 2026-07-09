import 'package:equatable/equatable.dart';
import 'package:flutter_knp_mobile_app_v2/modules/auth/domain/entities/auth_user.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, verificationSent, error }

class AppAuthState extends Equatable {
  const AppAuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.error,
    this.verificationEmail,
  });

  final AuthStatus status;
  final AuthUser? user;
  final String? error;
  final String? verificationEmail;

  bool get isLoading => status == AuthStatus.loading;

  AppAuthState copyWith({
    AuthStatus? status,
    AuthUser? user,
    String? error,
    String? verificationEmail,
  }) {
    return AppAuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error,
      verificationEmail: verificationEmail ?? this.verificationEmail,
    );
  }

  @override
  List<Object?> get props => [status, user, error, verificationEmail];
}
