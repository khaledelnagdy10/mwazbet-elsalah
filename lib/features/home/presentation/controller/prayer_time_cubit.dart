import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mwazbet_elsalah/features/home/domain/entities/entities.dart';
import 'package:mwazbet_elsalah/features/home/domain/use_cases/get_prayer_time.dart';

part 'prayer_time_state.dart';

class PrayerTimeCubit extends Cubit<PrayerTimeState> {
  final GetPrayerTime getPrayerTime;
  PrayerTimeCubit({required this.getPrayerTime}) : super(PrayerTimeInitial());

  Future<void> fetchPrayerTimes({required String city}) async {
    emit(PrayerTimeLoading());
    try {
      final prayerTime = await getPrayerTime.call(city: city);
      if (prayerTime == null) {
        emit(PrayerTimeFailure('No data received from API'));
      } else {
        emit(PrayerTimeSuccess(prayerTimeEntity: prayerTime));
      }
    } catch (e) {
      emit(PrayerTimeFailure(e.toString()));
    }
  }
}
