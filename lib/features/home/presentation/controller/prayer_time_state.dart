part of 'prayer_time_cubit.dart';

@immutable
sealed class PrayerTimeState {}

final class PrayerTimeInitial extends PrayerTimeState {}

final class PrayerTimeLoading extends PrayerTimeState {}

final class PrayerTimeSuccess extends PrayerTimeState {
  final PrayerTimeEntity prayerTimeEntity;
  final Map<String, dynamic> nextPrayers;

  PrayerTimeSuccess({
    required this.prayerTimeEntity,
    required this.nextPrayers,
  });
}

final class PrayerTimeFailure extends PrayerTimeState {
  final String errorMessage;
  PrayerTimeFailure(this.errorMessage);
}
