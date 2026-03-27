import 'package:mwazbet_elsalah/features/home/data/api/api.dart';
import 'package:mwazbet_elsalah/features/home/data/models/prayer_time_model.dart';
import 'package:mwazbet_elsalah/features/home/domain/entities/entities.dart';
import 'package:mwazbet_elsalah/features/home/domain/repos/prayer_time_repo.dart';

class PrayerTimeRepoImp implements PrayerTimeRepo {
  PrayerTimeRepoImp({required this.api});
  final Api api;
  @override
  Future<PrayerTimeEntity?> getPrayerTimes({required String city}) async {
    final prayerTime = await api.getPrayerTime(city: city);
    if (prayerTime.isEmpty) return null; // حماية لو الـ API فشل

    return PrayerTimeModel.fromJson(prayerTime);
  }
}
