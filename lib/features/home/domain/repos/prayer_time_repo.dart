import 'package:mwazbet_elsalah/features/home/domain/entities/entities.dart';

abstract class PrayerTimeRepo {
  Future<PrayerEntity?> getPrayerTimes({
    required String city,
    required DateTime date,
  });
}
