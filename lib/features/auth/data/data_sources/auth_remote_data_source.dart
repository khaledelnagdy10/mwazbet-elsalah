// auth_remote_data_source.dart

import 'package:mwazbet_elsalah/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String country,
    required String city,
    required String firstName,
    required String lastName,
  });

  Future<UserModel> logIn({required String email, required String password});

  Future<UserModel> signInWithGoogle();

  Future<UserModel> signInWithFacebook();

  Future<void> resetPassword({required String email});

  Future<void> signOut();

  Future<UserModel?> getCurrentUser();

  Future<void> saveCity({required String city});

  Future<void> updatePassword({
    required String oldPassword,
    required String newPassword,
  });

  Future<void> updateName({
    required String firstName,
    required String lastName,
  });

  Future<void> updateAddress({required String country, required String city});
}
