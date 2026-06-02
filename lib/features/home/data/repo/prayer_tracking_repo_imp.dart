import 'package:mwazbet_elsalah/features/home/data/data_source/prayer_tracking_remote_data_source.dart';
import 'package:mwazbet_elsalah/features/home/domain/entities/prayer_tracking_entities.dart';
import 'package:mwazbet_elsalah/features/home/domain/repos/prayer_tracking_repo.dart';

class PrayerTrackingRepoImp implements PrayerTrackingRepo {
  final PrayerTrackingRemoteDataSource remoteDataSource;

  PrayerTrackingRepoImp({required this.remoteDataSource});

  @override
  Future<void> savePrayerStatus({
    required String prayerName,
    required bool isPrayed,
    required String date,
  }) {
    return remoteDataSource.savePrayerStatus(
      prayerName: prayerName,
      isPrayed: isPrayed,
      date: date,
    );
  }

  @override
  Future<PrayerTrackingEntity?> getPrayerStatus({required String date}) {
    return remoteDataSource.getPrayerStatus(date: date);
  }
}
