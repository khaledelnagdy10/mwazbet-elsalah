import 'package:mwazbet_elsalah/features/family/data/data_sources/family_remote_data_source.dart';
import 'package:mwazbet_elsalah/features/family/data/models/family_request_model.dart';
import 'package:mwazbet_elsalah/features/family/domain/repos/family_repo.dart';

class FamilyRepoImp implements FamilyRepo {
  final FamilyRemoteDataSource remoteDataSource;

  FamilyRepoImp({required this.remoteDataSource});

  @override
  Future<void> sendRequest({required String receiverEmail}) {
    return remoteDataSource.sendRequest(receiverEmail: receiverEmail);
  }

  @override
  Future<List<FamilyRequestModel>> getPendingRequests() {
    return remoteDataSource.getPendingRequests();
  }

  @override
  Future<void> acceptRequest({required String requestId}) {
    return remoteDataSource.acceptRequest(requestId: requestId);
  }

  @override
  Future<void> rejectRequest({required String requestId}) {
    return remoteDataSource.rejectRequest(requestId: requestId);
  }
}
