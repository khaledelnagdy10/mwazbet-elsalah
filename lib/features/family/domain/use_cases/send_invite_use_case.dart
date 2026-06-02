import 'package:mwazbet_elsalah/features/family/domain/repos/family_repo.dart';

class SendRequestUseCase {
  final FamilyRepo familyRepo;

  SendRequestUseCase({required this.familyRepo});

  Future<void> call({required String receiverEmail}) {
    return familyRepo.sendRequest(receiverEmail: receiverEmail);
  }
}
