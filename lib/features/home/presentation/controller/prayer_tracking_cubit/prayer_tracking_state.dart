part of 'prayer_tracking_cubit.dart';

@immutable
sealed class PrayerTrackingState {}

final class PrayerTrackingInitial extends PrayerTrackingState {}

final class PrayerTrackingLoaded extends PrayerTrackingState {
  final PrayerTrackingEntity tracking;

  PrayerTrackingLoaded(this.tracking);
}

final class PrayerTrackingEmpty extends PrayerTrackingState {
  final String date;

  PrayerTrackingEmpty(this.date);
}

final class PrayerTrackingFailure extends PrayerTrackingState {
  final String message;

  PrayerTrackingFailure(this.message);
}
