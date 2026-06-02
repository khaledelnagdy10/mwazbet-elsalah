import 'package:mwazbet_elsalah/features/auth/domain/entities/user_entity.dart';
import 'package:mwazbet_elsalah/features/auth/domain/repos/auth_repo.dart';

class LogInUseCase {
  final AuthRepo authRepo;

  LogInUseCase({required this.authRepo});
  Future<UserEntity> call({required String email, required String password}) {
    return authRepo.logIn(email: email, password: password);
  }
}
