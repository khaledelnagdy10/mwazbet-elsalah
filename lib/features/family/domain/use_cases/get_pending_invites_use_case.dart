import 'package:mwazbet_elsalah/features/family/data/models/family_request_model.dart';
import 'package:mwazbet_elsalah/features/family/domain/repos/family_repo.dart';

class GetPendingRequestsUseCase {
  final FamilyRepo familyRepo;

  GetPendingRequestsUseCase({required this.familyRepo});

  Future<List<FamilyRequestModel>> call() {
    return familyRepo.getPendingRequests();
  }
}
