import 'package:mwazbet_elsalah/features/auth/domain/entities/user_entity.dart';
import 'package:mwazbet_elsalah/features/auth/domain/repos/auth_repo.dart';

class GetCurrentUser {
  final AuthRepo authRepo;

  GetCurrentUser({required this.authRepo});

  Future<UserEntity?> call() {
    return authRepo.getCurrentUser();
  }
}
