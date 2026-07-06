import 'package:flutter_knp_mobile_app_v2/modules/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_knp_mobile_app_v2/modules/auth/domain/entities/auth_user.dart';
import 'package:flutter_knp_mobile_app_v2/modules/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dataSource);

  final AuthRemoteDataSource _dataSource;

  @override
  Future<AuthUser> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _dataSource.signInWithEmail(email: email, password: password);
  }

  @override
  Future<AuthUser> signUpWithEmail({
    required String username,
    required String email,
    required String password,
  }) {
    return _dataSource.signUpWithEmail(
      username: username,
      email: email,
      password: password,
    );
  }

  @override
  Future<AuthUser?> signInWithGoogle() {
    return _dataSource.signInWithGoogle();
  }

  @override
  Future<void> signOut() {
    return _dataSource.signOut();
  }

  @override
  Future<AuthUser?> refreshAndCheckVerification() {
    return _dataSource.refreshAndCheckVerification();
  }

  @override
  AuthUser? getCurrentUser() {
    return _dataSource.getCurrentUser();
  }
}
