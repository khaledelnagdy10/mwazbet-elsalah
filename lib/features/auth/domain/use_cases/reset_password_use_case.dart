import 'package:mwazbet_elsalah/features/auth/domain/repos/auth_repo.dart';

class ResetPasswordUseCase {
  final AuthRepo authRepo;

  ResetPasswordUseCase({required this.authRepo});

  Future<void> call({required String email}) {
    return authRepo.resetPassword(email: email);
  }
}
