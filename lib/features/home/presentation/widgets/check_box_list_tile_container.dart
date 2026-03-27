import 'package:flutter/material.dart';
import 'package:mwazbet_elsalah/features/home/domain/entities/entities.dart';
import 'package:mwazbet_elsalah/features/home/presentation/widgets/check_box_list_tile.dart';

class CheckBoxListTileContainer extends StatelessWidget {
  const CheckBoxListTileContainer({super.key, required this.prayerTimesEntity});
  final PrayerEntity prayerTimesEntity;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          CheckBoxListTile(prayer: 'Fajr', prayerTime: prayerTimesEntity.fajr),
          CheckBoxListTile(prayer: 'Duhr', prayerTime: prayerTimesEntity.duhr),
          CheckBoxListTile(prayer: 'Asr', prayerTime: prayerTimesEntity.asr),
          CheckBoxListTile(
            prayer: 'Maghrib',
            prayerTime: prayerTimesEntity.maghrib,
          ),
          CheckBoxListTile(prayer: 'Isha', prayerTime: prayerTimesEntity.isha),
        ],
      ),
    );
  }
}
