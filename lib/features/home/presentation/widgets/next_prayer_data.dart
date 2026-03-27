import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mwazbet_elsalah/constants.dart';
import 'package:mwazbet_elsalah/features/home/presentation/controller/prayer_time_cubit.dart';

class NextPrayerData extends StatelessWidget {
  const NextPrayerData({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimeCubit, PrayerTimeState>(
      builder: (context, state) {
        if (state is PrayerTimeFailure) {
          return Center(child: Text('ERROR while get next prayer data'));
        }
        if (state is PrayerTimeSuccess) {
          return Column(
            children: [
              Positioned(
                child: Text(
                  'Next Prayer',
                  style: Style.bold20AllWhite(context),
                ),
              ),
              Divider(
                color: Colors.grey,
                thickness: 1,
                indent: 125,
                endIndent: 125,
              ),
              Text(
                state.nextPrayers.prayerName,
                style: Style.bold30AllWhite(context),
              ),
              Text('3:30:20', style: Style.bold30AllWhite(context)),
            ],
          );
        }

        return SizedBox();
      },
    );
  }
}
