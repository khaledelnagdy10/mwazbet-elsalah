import 'package:mwazbet_elsalah/features/home/data/models/prayer_tracking_model.dart';

abstract class PrayerTrackingRemoteDataSource {
  Future<void> savePrayerStatus({
    required String prayerName,
    required bool isPrayed,
    required String date,
  });

  Future<PrayerTrackingModel?> getPrayerStatus({required String date});
}
