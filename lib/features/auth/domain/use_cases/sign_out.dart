import 'package:mwazbet_elsalah/features/auth/domain/repos/auth_repo.dart';

class SignOutUseCase {
  final AuthRepo authRepo;

  SignOutUseCase({required this.authRepo});
  Future<void> call() {
    return authRepo.signOut();
  }
}
