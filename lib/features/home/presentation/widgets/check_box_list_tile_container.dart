import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mwazbet_elsalah/core/utils/format_date.dart';
import 'package:mwazbet_elsalah/features/home/domain/entities/prayer_entities.dart';
import 'package:mwazbet_elsalah/features/home/domain/entities/prayer_tracking_entities.dart';
import 'package:mwazbet_elsalah/features/home/presentation/controller/prayer_time_cubit/prayer_time_cubit.dart';
import 'package:mwazbet_elsalah/features/home/presentation/controller/prayer_tracking_cubit/prayer_tracking_cubit.dart';

import 'package:mwazbet_elsalah/features/home/presentation/widgets/check_box_list_tile.dart';

class CheckBoxListTileContainer extends StatefulWidget {
  const CheckBoxListTileContainer({super.key, required this.prayerEntity});

  final PrayerEntity prayerEntity;

  @override
  State<CheckBoxListTileContainer> createState() =>
      _CheckBoxListTileContainerState();
}

class _CheckBoxListTileContainerState extends State<CheckBoxListTileContainer> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadTracking();
  }

  @override
  void didUpdateWidget(covariant CheckBoxListTileContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadTracking();
  }

  void _loadTracking() {
    final selectedDate = context.read<PrayerTimeCubit>().selectedDate;
    final date = formatDate(selectedDate);

    context.read<PrayerTrackingCubit>().getPrayerStatus(date: date);
  }

  PrayerTrackingEntity _emptyTracking(String date) {
    return PrayerTrackingEntity(
      date: date,
      fajr: false,
      dhuhr: false,
      asr: false,
      maghrib: false,
      isha: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFriday =
        context.watch<PrayerTimeCubit>().selectedDate.weekday ==
        DateTime.friday;

    final selectedDate = context.watch<PrayerTimeCubit>().selectedDate;
    final date = formatDate(selectedDate);

    return BlocBuilder<PrayerTrackingCubit, PrayerTrackingState>(
      builder: (context, state) {
        PrayerTrackingEntity tracking = _emptyTracking(date);

        if (state is PrayerTrackingLoaded) {
          tracking = state.tracking;
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black.withOpacity(0.07)),
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
                  CheckBoxListTile(
                    prayer: 'Fajr'.tr(),
                    prayerTime: widget.prayerEntity.fajr,
                    isPrayed: tracking.fajr,
                    date: date,
                  ),
                  CheckBoxListTile(
                    prayer: isFriday ? "Juma'a".tr() : "Dhuhr".tr(),
                    prayerTime: widget.prayerEntity.duhr,
                    isPrayed: tracking.dhuhr,
                    date: date,
                  ),
                  CheckBoxListTile(
                    prayer: 'Asr'.tr(),
                    prayerTime: widget.prayerEntity.asr,
                    isPrayed: tracking.asr,
                    date: date,
                  ),
                  CheckBoxListTile(
                    prayer: 'Maghrib'.tr(),
                    prayerTime: widget.prayerEntity.maghrib,
                    isPrayed: tracking.maghrib,
                    date: date,
                  ),
                  CheckBoxListTile(
                    prayer: 'Isha'.tr(),
                    prayerTime: widget.prayerEntity.isha,
                    isPrayed: tracking.isha,
                    date: date,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
