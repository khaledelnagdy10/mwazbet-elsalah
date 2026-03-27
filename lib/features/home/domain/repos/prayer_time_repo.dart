import 'package:mwazbet_elsalah/features/home/domain/entities/entities.dart';

abstract class PrayerTimeRepo {
  Future<PrayerTimeEntity?> getPrayerTimes({required String city});
}
