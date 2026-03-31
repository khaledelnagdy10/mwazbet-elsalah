class GetRemainingTimeUseCase {
  Duration call(DateTime prayerTime) {
    return prayerTime.difference(DateTime.now());
  }
}
