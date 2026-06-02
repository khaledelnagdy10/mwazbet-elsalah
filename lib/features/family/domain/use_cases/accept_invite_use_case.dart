import 'package:mwazbet_elsalah/features/family/domain/repos/family_repo.dart';

class AcceptRequestUseCase {
  final FamilyRepo familyRepo;

  AcceptRequestUseCase({required this.familyRepo});

  Future<void> call({required String requestId}) {
    return familyRepo.acceptRequest(requestId: requestId);
  }
}
