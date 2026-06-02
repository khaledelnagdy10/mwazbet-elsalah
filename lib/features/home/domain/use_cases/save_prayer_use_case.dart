import 'package:mwazbet_elsalah/features/home/domain/repos/prayer_tracking_repo.dart';

class SavePrayerStatusUseCase {
  final PrayerTrackingRepo repo;

  SavePrayerStatusUseCase({required this.repo});

  Future<void> call({
    required String prayerName,
    required bool isPrayed,
    required String date,
  }) {
    return repo.savePrayerStatus(
      prayerName: prayerName,
      isPrayed: isPrayed,
      date: date,
    );
  }
}
