import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mwazbet_elsalah/constants.dart';
import 'package:mwazbet_elsalah/features/home/presentation/controller/prayer_time_cubit.dart';
import 'package:mwazbet_elsalah/features/home/presentation/widgets/city_bottom_sheet.dart';

class UserLocation extends StatelessWidget {
  const UserLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimeCubit, PrayerTimeState>(
      builder: (context, state) {
        final city = context.read<PrayerTimeCubit>().selectedCity;

        return Row(
          children: [
            Text(city, style: Style.kPrimaryTextColor(context)),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => showCityPicker(context),
              child: Text('Change city', style: Style.text12Grey(context)),
            ),
          ],
        );
      },
    );
  }
}
