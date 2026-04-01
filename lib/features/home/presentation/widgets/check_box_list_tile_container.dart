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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          CheckBoxListTile(prayer: 'Fajr', prayerTime: prayerEntity.fajr),
          CheckBoxListTile(
            prayer: isFriday ? "Juma'a" : "Dhuhr",
            prayerTime: prayerEntity.duhr,
          ),
          CheckBoxListTile(prayer: 'Asr', prayerTime: prayerEntity.asr),
          CheckBoxListTile(prayer: 'Maghrib', prayerTime: prayerEntity.maghrib),
          CheckBoxListTile(prayer: 'Isha', prayerTime: prayerEntity.isha),
        ],
      ),
    );
  }
}
