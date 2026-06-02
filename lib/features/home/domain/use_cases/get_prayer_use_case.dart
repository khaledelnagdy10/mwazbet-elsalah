import 'package:mwazbet_elsalah/features/home/domain/entities/prayer_tracking_entities.dart';
import 'package:mwazbet_elsalah/features/home/domain/repos/prayer_tracking_repo.dart';

class GetPrayerStatusUseCase {
  final PrayerTrackingRepo repo;

  GetPrayerStatusUseCase({required this.repo});

  Future<PrayerTrackingEntity?> call({required String date}) {
    return repo.getPrayerStatus(date: date);
  }
}
