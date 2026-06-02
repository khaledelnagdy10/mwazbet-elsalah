import 'package:mwazbet_elsalah/features/auth/domain/repos/auth_repo.dart';

class UpdateAddressUseCase {
  final AuthRepo authRepo;

  UpdateAddressUseCase({required this.authRepo});

  Future<void> call({required String country, required String city}) {
    return authRepo.updateAddress(country: country, city: city);
  }
}
