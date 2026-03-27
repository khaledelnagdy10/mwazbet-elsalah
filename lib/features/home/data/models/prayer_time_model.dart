import 'package:mwazbet_elsalah/features/home/domain/entities/entities.dart';

class PrayerTimeModel extends PrayerTimeEntity {
  PrayerTimeModel({
    required super.fajr,
    required super.duhr,
    required super.asr,
    required super.maghrib,
    required super.isha,
  });
  // final String fajr;
  // final String duhr;
  // final String asr;
  // final String maghrib;
  // final String isha;

  // PrayerTimeModel({
  //   required this.fajr,
  //   required this.duhr,
  //   required this.asr,
  //   required this.maghrib,
  //   required this.isha,
  // });

  factory PrayerTimeModel.fromJson(Map<String, dynamic> json) {
    return PrayerTimeModel(
      fajr: json['Fajr'] as String,
      duhr: json['Dhuhr'] as String,
      asr: json['Asr'] as String,
      maghrib: json['Maghrib'] as String,
      isha: json['Isha'] as String,
    );
  }
}
// static String _formatTimeTo12Hour(String time24) {
//     String cleanTime = time24.split(' ').first;

//     DateTime dateTime = DateFormat('HH:mm').parse(cleanTime);
//     return DateFormat('h:mm a').format(dateTime);
//   }
