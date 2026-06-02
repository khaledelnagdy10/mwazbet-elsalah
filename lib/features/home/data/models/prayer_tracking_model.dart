import 'package:mwazbet_elsalah/features/home/domain/entities/prayer_tracking_entities.dart';

class PrayerTrackingModel extends PrayerTrackingEntity {
  PrayerTrackingModel({
    required super.date,
    required super.fajr,
    required super.dhuhr,
    required super.asr,
    required super.maghrib,
    required super.isha,
  });

  factory PrayerTrackingModel.fromJson(Map<String, dynamic> json) {
    return PrayerTrackingModel(
      date: json['date'] ?? '',
      fajr: json['fajr'] ?? false,
      dhuhr: json['dhuhr'] ?? false,
      asr: json['asr'] ?? false,
      maghrib: json['maghrib'] ?? false,
      isha: json['isha'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'fajr': fajr,
      'dhuhr': dhuhr,
      'asr': asr,
      'maghrib': maghrib,
      'isha': isha,
    };
  }
}
