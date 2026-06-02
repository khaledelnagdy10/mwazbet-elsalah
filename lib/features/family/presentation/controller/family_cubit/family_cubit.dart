import 'package:bloc/bloc.dart';
import 'package:mwazbet_elsalah/features/family/data/models/family_request_model.dart';
import 'package:mwazbet_elsalah/features/family/domain/use_cases/accept_invite_use_case.dart';
import 'package:mwazbet_elsalah/features/family/domain/use_cases/get_pending_invites_use_case.dart';
import 'package:mwazbet_elsalah/features/family/domain/use_cases/reject_invite_use_case.dart';
import 'package:mwazbet_elsalah/features/family/domain/use_cases/send_invite_use_case.dart';

part 'family_state.dart';

class FamilyCubit extends Cubit<FamilyState> {
  FamilyCubit({
    required this.sendRequestUseCase,
    required this.getPendingRequestsUseCase,
    required this.acceptRequestUseCase,
    required this.rejectRequestUseCase,
  }) : super(FamilyInitial());

  final SendRequestUseCase sendRequestUseCase;
  final GetPendingRequestsUseCase getPendingRequestsUseCase;
  final AcceptRequestUseCase acceptRequestUseCase;
  final RejectRequestUseCase rejectRequestUseCase;

  Future<void> sendRequest({required String receiverEmail}) async {
    emit(FamilyLoading());

    try {
      await sendRequestUseCase(receiverEmail: receiverEmail);
      emit(FamilyRequestSent());
    } catch (e) {
      emit(FamilyFailure(e.toString()));
    }
  }

  Future<void> loadPendingRequests() async {
    emit(FamilyLoading());

    try {
      final requests = await getPendingRequestsUseCase();
      emit(FamilyRequestsLoaded(requests));
    } catch (e) {
      emit(FamilyFailure(e.toString()));
    }
  }

  Future<void> acceptRequest({required String requestId}) async {
    emit(FamilyLoading());

    try {
      await acceptRequestUseCase(requestId: requestId);
      await loadPendingRequests();
    } catch (e) {
      emit(FamilyFailure(e.toString()));
    }
  }

  Future<void> rejectRequest({required String requestId}) async {
    emit(FamilyLoading());

    try {
      await rejectRequestUseCase(requestId: requestId);
      await loadPendingRequests();
    } catch (e) {
      emit(FamilyFailure(e.toString()));
    }
  }
}
