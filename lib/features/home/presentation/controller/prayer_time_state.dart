part of 'prayer_time_cubit.dart';

sealed class PrayerTimeState {}

final class PrayerTimeInitial extends PrayerTimeState {}

final class PrayerTimeLoading extends PrayerTimeState {}

final class PrayerTimeSuccess extends PrayerTimeState {
  final PrayerEntity prayerTimeEntity;
  final NextPrayerEntity nextPrayer;
  final Duration remaining;

  PrayerTimeSuccess({
    required this.prayerTimeEntity,
    required this.nextPrayer,
    required this.remaining,
  });
}

final class PrayerTimeFailure extends PrayerTimeState {
  final String errorMessage;
  PrayerTimeFailure(this.errorMessage);
}
