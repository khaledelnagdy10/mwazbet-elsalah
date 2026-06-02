// auth_repo_imp.dart

import 'package:mwazbet_elsalah/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:mwazbet_elsalah/features/auth/domain/entities/user_entity.dart';
import 'package:mwazbet_elsalah/features/auth/domain/repos/auth_repo.dart';

class AuthRepoImp implements AuthRepo {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepoImp({required this.authRemoteDataSource});

  @override
  Future<UserEntity> signUp({
    required String email,
    required String password,
    required String country,
    required String city,
    required String firstName,
    required String lastName,
  }) {
    return authRemoteDataSource.signUp(
      email: email,
      password: password,
      country: country,
      city: city,
      firstName: firstName,
      lastName: lastName,
    );
  }

  @override
  Future<UserEntity> logIn({required String email, required String password}) {
    return authRemoteDataSource.logIn(email: email, password: password);
  }

  @override
  Future<UserEntity> signInWithGoogle() {
    return authRemoteDataSource.signInWithGoogle();
  }

  @override
  Future<UserEntity> signInWithFacebook() {
    return authRemoteDataSource.signInWithFacebook();
  }

  @override
  Future<void> resetPassword({required String email}) {
    return authRemoteDataSource.resetPassword(email: email);
  }

  @override
  Future<void> signOut() {
    return authRemoteDataSource.signOut();
  }

  @override
  Future<UserEntity?> getCurrentUser() {
    return authRemoteDataSource.getCurrentUser();
  }

  @override
  Future<void> saveCity({required String city}) {
    return authRemoteDataSource.saveCity(city: city);
  }

  @override
  Future<void> updatePassword({
    required String oldPassword,
    required String newPassword,
  }) {
    return authRemoteDataSource.updatePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }

  @override
  Future<void> updateName({
    required String firstName,
    required String lastName,
  }) {
    return authRemoteDataSource.updateName(
      firstName: firstName,
      lastName: lastName,
    );
  }

  @override
  Future<void> updateAddress({required String country, required String city}) {
    return authRemoteDataSource.updateAddress(country: country, city: city);
  }
}
