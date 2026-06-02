part of 'family_cubit.dart';

sealed class FamilyState {}

final class FamilyInitial extends FamilyState {}

final class FamilyLoading extends FamilyState {}

final class FamilyRequestSent extends FamilyState {}

final class FamilyRequestsLoaded extends FamilyState {
  final List<FamilyRequestModel> requests;

  FamilyRequestsLoaded(this.requests);
}

final class FamilyActionSuccess extends FamilyState {}

final class FamilyFailure extends FamilyState {
  final String message;

  FamilyFailure(this.message);
}
