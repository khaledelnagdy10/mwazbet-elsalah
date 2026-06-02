import 'package:mwazbet_elsalah/features/auth/domain/repos/auth_repo.dart';

class SaveCityUseCase {
  final AuthRepo authRepo;

  SaveCityUseCase({required this.authRepo});

  Future<void> call({required String city}) {
    return authRepo.saveCity(city: city);
  }
}
