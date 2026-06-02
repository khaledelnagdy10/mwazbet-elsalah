import 'package:mwazbet_elsalah/features/family/domain/repos/family_repo.dart';

class RejectRequestUseCase {
  final FamilyRepo familyRepo;

  RejectRequestUseCase({required this.familyRepo});

  Future<void> call({required String requestId}) {
    return familyRepo.rejectRequest(requestId: requestId);
  }
}
