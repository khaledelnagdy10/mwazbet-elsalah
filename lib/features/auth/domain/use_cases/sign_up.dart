import 'package:mwazbet_elsalah/features/auth/domain/entities/user_entity.dart';
import 'package:mwazbet_elsalah/features/auth/domain/repos/auth_repo.dart';

class SignUpUseCase {
  final AuthRepo authRepo;

  SignUpUseCase({required this.authRepo});

  Future<UserEntity> call({
    required String email,
    required String password,
    required String country,
    required String city,
    required String firstName,
    required String lastName,
  }) {
    return authRepo.signUp(
      email: email,
      password: password,
      country: country,
      city: city,
      firstName: firstName,
      lastName: lastName,
    );
  }
}
