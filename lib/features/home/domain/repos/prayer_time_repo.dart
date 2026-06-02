import 'package:mwazbet_elsalah/features/home/domain/entities/prayer_entities.dart';

abstract class PrayerTimeRepo {
  Future<PrayerEntity?> getPrayerTimes({
    required String city,
    required DateTime date,
  });
}
