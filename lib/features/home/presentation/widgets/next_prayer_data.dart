import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mwazbet_elsalah/constants.dart';
import 'package:mwazbet_elsalah/features/home/presentation/controller/prayer_time_cubit/prayer_time_cubit.dart';

class NextPrayerData extends StatelessWidget {
  const NextPrayerData({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimeCubit, PrayerTimeState>(
      builder: (context, state) {
        if (state is PrayerTimeFailure) {
          return const Center(child: Text('ERROR while get next prayer data'));
        }

        if (state is PrayerTimeSuccess) {
          final remaining = state.remaining;

          String format(Duration d) {
            String twoDigits(int n) => n.toString().padLeft(2, '0');

            return "${twoDigits(d.inHours)}:"
                "${twoDigits(d.inMinutes.remainder(60))}:"
                "${twoDigits(d.inSeconds.remainder(60))}";
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Next Prayer'.tr(), style: Style.bold30AllWhite),

              const SizedBox(height: 2),

              Divider(
                color: Colors.grey,
                thickness: 1,
                indent: 125,
                endIndent: 125,
              ),

              const SizedBox(height: 4),

              Text(
                '${state.nextPrayer.prayerName}'.tr(),
                style: Style.bold30AllWhite,
              ),

              const SizedBox(height: 4),

              Text(format(remaining), style: Style.bold30AllWhite),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}
