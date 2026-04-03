import 'dart:async';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:mwazbet_elsalah/features/home/domain/entities/entities.dart';
import 'package:mwazbet_elsalah/features/home/domain/entities/next_prayer_entity.dart';
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

  Future<void> fetchPrayerTimes({
    required String city,
    DateTime? selectedDate,
  }) async {
    _hasPlayedAdhan = false;
    emit(PrayerTimeLoading());

    final date = selectedDate ?? this.selectedDate;

    final nextPrayerTime = await getPrayerTime.call(city: city, date: date);
    final todayNextPrayerTime = await getPrayerTime.call(
      city: city,
      date: DateTime.now(),
    );

    if (nextPrayerTime == null) {
      emit(PrayerTimeFailure('No data'));
      return;
    }

    final nextPrayer = getNextPrayer.getNextPrayer(
      prayerTimeEntity: todayNextPrayerTime!,
    );
    log("NEXT PRAYER NAME: ${nextPrayer.prayerName}");
    log("NEXT PRAYER TIME: ${nextPrayer.prayerTime}");

    _startTimer(prayerTime: nextPrayerTime, nextPrayer: nextPrayer, city: city);
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
        _playAdhan();

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

  void changeDate(DateTime newDate) {
    selectedDate = newDate;

    fetchPrayerTimes(city: selectedCity, selectedDate: newDate);
  }

  void changeCity(String city) {
    selectedCity = city;

    fetchPrayerTimes(city: city, selectedDate: selectedDate);
  }

  Future<void> _playAdhan() async {
    await _player.play(AssetSource('audio/azan.mp3'));
  }

  Future<void> testAdhan() async {
    await _playAdhan();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
