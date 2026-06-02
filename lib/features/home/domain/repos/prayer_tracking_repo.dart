import 'package:mwazbet_elsalah/features/home/domain/entities/prayer_tracking_entities.dart';

abstract class PrayerTrackingRepo {
  Future<void> savePrayerStatus({
    required String prayerName,
    required bool isPrayed,
    required String date,
  });

  Future<PrayerTrackingEntity?> getPrayerStatus({required String date});
}
