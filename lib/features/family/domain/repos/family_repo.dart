import 'package:mwazbet_elsalah/features/family/data/models/family_request_model.dart';

abstract class FamilyRepo {
  Future<void> sendRequest({required String receiverEmail});

  Future<List<FamilyRequestModel>> getPendingRequests();

  Future<void> acceptRequest({required String requestId});

  Future<void> rejectRequest({required String requestId});
}
