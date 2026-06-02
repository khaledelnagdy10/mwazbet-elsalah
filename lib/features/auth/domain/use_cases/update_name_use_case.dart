// update_name_use_case.dart

import 'package:mwazbet_elsalah/features/auth/domain/repos/auth_repo.dart';

class UpdateNameUseCase {
  final AuthRepo authRepo;

  UpdateNameUseCase({required this.authRepo});

  Future<void> call({required String firstName, required String lastName}) {
    return authRepo.updateName(firstName: firstName, lastName: lastName);
  }
}
