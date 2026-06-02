import 'package:mwazbet_elsalah/features/auth/domain/entities/user_entity.dart';
import 'package:mwazbet_elsalah/features/auth/domain/repos/auth_repo.dart';

class SignInWithGoogleUseCase {
  final AuthRepo authRepo;

  SignInWithGoogleUseCase({required this.authRepo});

  Future<UserEntity> call() {
    return authRepo.signInWithGoogle();
  }
}
