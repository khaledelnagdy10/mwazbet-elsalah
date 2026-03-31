class NextPrayerEntity {
  final String prayerName;
  final DateTime prayerTime;

  NextPrayerEntity({
    required this.prayerName,
    required this.prayerTime,
    DateTime? currentTime,
  });
}
