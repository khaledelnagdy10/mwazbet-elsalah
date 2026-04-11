import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mwazbet_elsalah/features/home/domain/entities/entities.dart';
import 'package:mwazbet_elsalah/features/home/presentation/controller/prayer_time_cubit.dart';
import 'package:mwazbet_elsalah/features/home/presentation/widgets/check_box_list_tile.dart';

class CheckBoxListTileContainer extends StatelessWidget {
  const CheckBoxListTileContainer({super.key, required this.prayerEntity});
  final PrayerEntity prayerEntity;

  @override
  Widget build(BuildContext context) {
    final isFriday =
        context.read<PrayerTimeCubit>().selectedDate.weekday == DateTime.friday;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),

            /// border خفيف
            border: Border.all(color: Colors.black.withOpacity(0.07)),

            /// shadow بسيط
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              CheckBoxListTile(prayer: 'Fajr', prayerTime: prayerEntity.fajr),

              CheckBoxListTile(
                prayer: isFriday ? "Juma'a" : "Dhuhr",
                prayerTime: prayerEntity.duhr,
              ),

              CheckBoxListTile(prayer: 'Asr', prayerTime: prayerEntity.asr),

              CheckBoxListTile(
                prayer: 'Maghrib',
                prayerTime: prayerEntity.maghrib,
              ),

              CheckBoxListTile(prayer: 'Isha', prayerTime: prayerEntity.isha),
            ],
          ),
        ),
      ),
    );
  }
}
