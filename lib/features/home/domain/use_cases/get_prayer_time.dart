import 'package:mwazbet_elsalah/features/home/domain/entities/entities.dart';
import 'package:mwazbet_elsalah/features/home/domain/repos/prayer_time_repo.dart';

class GetPrayerTime {
  final PrayerTimeRepo prayerTimeRepo;

  GetPrayerTime({required this.prayerTimeRepo});

  Future<PrayerEntity?> call({
    required String city,
    required DateTime date,
  }) async {
    return await prayerTimeRepo.getPrayerTimes(city: city, date: date);
  }
}
