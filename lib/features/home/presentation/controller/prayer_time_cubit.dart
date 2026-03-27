import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mwazbet_elsalah/features/home/domain/entities/entities.dart';
import 'package:mwazbet_elsalah/features/home/domain/use_cases/get_next_prayer.dart';
import 'package:mwazbet_elsalah/features/home/domain/use_cases/get_prayer_time.dart';

part 'prayer_time_state.dart';

class PrayerTimeCubit extends Cubit<PrayerTimeState> {
  PrayerTimeCubit({required this.getPrayerTime, required this.getNextPrayer})
    : super(PrayerTimeInitial());
  final GetPrayerTime getPrayerTime;

  final GetNextPrayer getNextPrayer;
  Future<void> fetchPrayerTimes({required String city}) async {
    emit(PrayerTimeLoading());
    try {
      final prayerTime = await getPrayerTime.call(city: city);
      if (prayerTime == null) {
        emit(PrayerTimeFailure('No data received from API'));
      }
      final nextPrayer = getNextPrayer.getNextPrayer(
        prayerTimeEntity: prayerTime!,
      );

      emit(
        PrayerTimeSuccess(
          prayerTimeEntity: prayerTime,
          nextPrayers: nextPrayer,
        ),
      );
    } catch (e) {
      emit(PrayerTimeFailure(e.toString()));
    }
  }
}
