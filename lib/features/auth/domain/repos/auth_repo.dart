import 'package:mwazbet_elsalah/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepo {
  Future<UserEntity> signUp({
    required String email,
    required String password,
    required String country,
    required String city,
    required String firstName,
    required String lastName,
  });

  Future<UserEntity> logIn({required String email, required String password});

  Future<UserEntity> signInWithGoogle();

  Future<UserEntity> signInWithFacebook();

  Future<void> resetPassword({required String email});

  Future<void> signOut();

  Future<UserEntity?> getCurrentUser();

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
