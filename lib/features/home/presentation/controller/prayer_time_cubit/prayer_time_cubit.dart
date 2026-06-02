import 'dart:async';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:mwazbet_elsalah/core/services/notification_service.dart';
import 'package:mwazbet_elsalah/features/home/domain/entities/next_prayer_entity.dart';
import 'package:mwazbet_elsalah/features/home/domain/entities/prayer_entities.dart';
import 'package:mwazbet_elsalah/features/home/domain/use_cases/get_next_prayer.dart';
import 'package:mwazbet_elsalah/features/home/domain/use_cases/get_prayer_time.dart';
import 'package:mwazbet_elsalah/features/home/domain/use_cases/get_remaining_time.dart';

part 'prayer_time_state.dart';

class PrayerTimeCubit extends Cubit<PrayerTimeState> {
  PrayerTimeCubit({
    required this.getPrayerTime,
    required this.getNextPrayer,
    required this.getRemainingTime,
  }) : super(PrayerTimeInitial());

  final GetPrayerTime getPrayerTime;
  final GetNextPrayer getNextPrayer;
  final GetRemainingTimeUseCase getRemainingTime;

  Timer? _timer;

  DateTime selectedDate = DateTime.now();
  String selectedCity = 'Suez';

  final AudioPlayer _player = AudioPlayer();
  bool _hasPlayedAdhan = false;

  Map<String, bool> azanNotification = {
    'Fajr': true,
    'Dhuhr': true,
    'Asr': true,
    'Maghrib': true,
    'Isha': true,
  };

  Future<void> fetchPrayerTimes({
    required String city,
    DateTime? selectedDate,
  }) async {
    _hasPlayedAdhan = false;
    emit(PrayerTimeLoading());

    final date = selectedDate ?? this.selectedDate;

    this.selectedCity = city;
    this.selectedDate = date;

    try {
      log('FETCH CITY: $city');
      log('FETCH DATE: $date');

      final nextPrayerTime = await getPrayerTime.call(
        city: city.trim(),
        date: date,
      );

      final todayNextPrayerTime = await getPrayerTime.call(
        city: city.trim(),
        date: DateTime.now(),
      );

      if (nextPrayerTime == null) {
        emit(PrayerTimeFailure('No prayer times found for selected date'));
        return;
      }

      if (todayNextPrayerTime == null) {
        emit(PrayerTimeFailure('No prayer times found for today'));
        return;
      }

      await _scheduleAllPrayers(todayNextPrayerTime);

      final nextPrayer = getNextPrayer.getNextPrayer(
        prayerTimeEntity: todayNextPrayerTime,
      );

      _startTimer(
        prayerTime: nextPrayerTime,
        nextPrayer: nextPrayer,
        city: city,
      );
    } catch (e) {
      log('FETCH ERROR: $e');
      emit(PrayerTimeFailure(e.toString()));
    }
  }

  Future<void> _scheduleAllPrayers(PrayerEntity prayer) async {
    await NotificationService.cancelAll();

    final prayers = [
      {'id': 1, 'name': 'Fajr', 'time': prayer.fajr},
      {'id': 2, 'name': 'Dhuhr', 'time': prayer.duhr},
      {'id': 3, 'name': 'Asr', 'time': prayer.asr},
      {'id': 4, 'name': 'Maghrib', 'time': prayer.maghrib},
      {'id': 5, 'name': 'Isha', 'time': prayer.isha},
    ];

    for (final prayerData in prayers) {
      final prayerTime = _parsePrayerTime(prayerData['time'] as String);

      if (prayerTime.isAfter(DateTime.now()) &&
          azanNotification[prayerData['name']] == true) {
        await NotificationService.schedulePrayer(
          id: prayerData['id'] as int,
          prayerName: prayerData['name'] as String,
          prayerTime: prayerTime,
        );
      }
    }
  }

  DateTime _parsePrayerTime(String time) {
    final parsed = DateFormat('h:mm a').parse(time);
    final now = DateTime.now();

    return DateTime(now.year, now.month, now.day, parsed.hour, parsed.minute);
  }

  void _startTimer({
    required PrayerEntity prayerTime,
    required NextPrayerEntity nextPrayer,
    required String city,
  }) {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final remaining = getRemainingTime(nextPrayer.prayerTime);
      final safeRemaining = remaining.isNegative ? Duration.zero : remaining;

      if (remaining.inSeconds <= 0 && !_hasPlayedAdhan) {
        _hasPlayedAdhan = true;
        _timer?.cancel();

        fetchPrayerTimes(city: city, selectedDate: DateTime.now());
        return;
      }

      emit(
        PrayerTimeSuccess(
          prayerTimeEntity: prayerTime,
          nextPrayer: nextPrayer,
          remaining: safeRemaining,
        ),
      );
    });
  }

  Future<void> changeDate(DateTime newDate) async {
    selectedDate = newDate;
    await fetchPrayerTimes(city: selectedCity, selectedDate: newDate);
  }

  Future<void> getCity(String city) async {
    selectedCity = city.trim();
    await fetchPrayerTimes(city: selectedCity, selectedDate: selectedDate);
  }

  // Future<void> _playAdhan() async {
  //   await _player.play(AssetSource('audio/azan.mp3'));
  // }

  void toogleAzan(String prayerName, bool value) {
    azanNotification[prayerName] = value;

    fetchPrayerTimes(city: selectedCity, selectedDate: selectedDate);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
