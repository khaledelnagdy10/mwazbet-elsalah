import 'package:intl/intl.dart';
import 'package:mwazbet_elsalah/features/home/domain/entities/entities.dart';

class GetNextPrayer {
  Map<String, dynamic> getNextPrayer({
    required PrayerTimeEntity prayerTimeEntity,
  }) {
    final now = DateTime.now();
    DateTime parse(String time) {
      return DateFormat('h:mm a').parse(time);
    }

    Map<String, dynamic> prayersTime = {
      'Fajr': parse(prayerTimeEntity.fajr),
      'Dhuhr': parse(prayerTimeEntity.duhr),
      'Asr': parse(prayerTimeEntity.asr),
      'Maghrib': parse(prayerTimeEntity.maghrib),
      'Isha': parse(prayerTimeEntity.isha),
    };
    for (var entry in prayersTime.entries) {
      if (entry.value.isAfter(now)) {
        return {
          'name': entry.key,
          'time': DateFormat('h:mm a').format(entry.value),
        };
      }
    }
    return {'name': 'Fajr', 'time': prayerTimeEntity.fajr};
  }
}
