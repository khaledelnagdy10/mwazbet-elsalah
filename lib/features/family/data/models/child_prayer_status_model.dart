class ChildPrayerStatusModel {
  final String date;
  final bool fajr;
  final bool dhuhr;
  final bool asr;
  final bool maghrib;
  final bool isha;

  ChildPrayerStatusModel({
    required this.date,
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  factory ChildPrayerStatusModel.empty(String date) {
    return ChildPrayerStatusModel(
      date: date,
      fajr: false,
      dhuhr: false,
      asr: false,
      maghrib: false,
      isha: false,
    );
  }

  factory ChildPrayerStatusModel.fromJson(Map<String, dynamic> json) {
    return ChildPrayerStatusModel(
      date: json['date'] ?? '',
      fajr: json['fajr'] ?? false,
      dhuhr: json['dhuhr'] ?? false,
      asr: json['asr'] ?? false,
      maghrib: json['maghrib'] ?? false,
      isha: json['isha'] ?? false,
    );
  }

  int get prayedCount {
    return [fajr, dhuhr, asr, maghrib, isha].where((e) => e).length;
  }
}
