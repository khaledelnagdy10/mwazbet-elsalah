import 'package:intl/intl.dart';
import 'package:mwazbet_elsalah/features/home/domain/entities/entities.dart';
import 'package:mwazbet_elsalah/features/home/domain/entities/next_prayer_entity.dart';

class GetNextPrayer {
  NextPrayerEntity getNextPrayer({required PrayerEntity prayerTimeEntity}) {
    final now = DateTime.now();

    DateTime parse(String time) {
      final parsed = DateFormat('h:mm a').parse(time);

      return DateTime(now.year, now.month, now.day, parsed.hour, parsed.minute);
    }

    final prayers = [
      {'name': 'Fajr', 'time': parse(prayerTimeEntity.fajr)},
      {'name': 'Dhuhr', 'time': parse(prayerTimeEntity.duhr)},
      {'name': 'Asr', 'time': parse(prayerTimeEntity.asr)},
      {'name': 'Maghrib', 'time': parse(prayerTimeEntity.maghrib)},
      {'name': 'Isha', 'time': parse(prayerTimeEntity.isha)},
    ];

    for (var prayer in prayers) {
      if ((prayer['time'] as DateTime).isAfter(now)) {
        return NextPrayerEntity(
          prayerName: prayer['name'] as String,
          prayerTime: prayer['time'] as DateTime,
        );
      }
    }

    final fajrTomorrow = parse(
      prayerTimeEntity.fajr,
    ).add(const Duration(days: 1));

    return NextPrayerEntity(
      prayerName: prayerTimeEntity.fajr,
      prayerTime: fajrTomorrow,
    );
  }
}
