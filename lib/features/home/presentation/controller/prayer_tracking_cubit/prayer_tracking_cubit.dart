import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mwazbet_elsalah/features/home/domain/entities/prayer_tracking_entities.dart';

import 'package:mwazbet_elsalah/features/home/domain/use_cases/get_prayer_use_case.dart';
import 'package:mwazbet_elsalah/features/home/domain/use_cases/save_prayer_use_case.dart';

part 'prayer_tracking_state.dart';

class PrayerTrackingCubit extends Cubit<PrayerTrackingState> {
  PrayerTrackingCubit({
    required this.savePrayerStatusUseCase,
    required this.getPrayerStatusUseCase,
  }) : super(PrayerTrackingInitial());

  final SavePrayerStatusUseCase savePrayerStatusUseCase;
  final GetPrayerStatusUseCase getPrayerStatusUseCase;

  Future<void> savePrayer({
    required String prayerName,
    required bool isPrayed,
    required String date,
  }) async {
    try {
      await savePrayerStatusUseCase(
        prayerName: prayerName,
        isPrayed: isPrayed,
        date: date,
      );

      await getPrayerStatus(date: date);
    } catch (e) {
      emit(PrayerTrackingFailure(e.toString()));
    }
  }

  Future<void> getPrayerStatus({required String date}) async {
    try {
      final data = await getPrayerStatusUseCase(date: date);

      if (data == null) {
        emit(PrayerTrackingEmpty(date));
      } else {
        emit(PrayerTrackingLoaded(data));
      }
    } catch (e) {
      emit(PrayerTrackingFailure(e.toString()));
    }
  }
}
