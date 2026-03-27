import 'package:intl/intl.dart';
import 'package:mwazbet_elsalah/features/home/domain/entities/entities.dart';

class PrayerTimeModel extends PrayerEntity {
  PrayerTimeModel({
    required super.fajr,
    required super.duhr,
    required super.asr,
    required super.maghrib,
    required super.isha,
  });

  factory PrayerTimeModel.fromJson(Map<String, dynamic> json) {
    return PrayerTimeModel(
      fajr: _formatTimeTo12Hour(json['Fajr'] as String),
      duhr: _formatTimeTo12Hour(json['Dhuhr'] as String),
      asr: _formatTimeTo12Hour(json['Asr'] as String),
      maghrib: _formatTimeTo12Hour(json['Maghrib'] as String),
      isha: _formatTimeTo12Hour(json['Isha'] as String),
    );
  }
  static String _formatTimeTo12Hour(String time24) {
    String cleanTime = time24.split(' ').first;

    DateTime dateTime = DateFormat('HH:mm').parse(cleanTime);
    return DateFormat('h:mm a').format(dateTime);
  }
}
