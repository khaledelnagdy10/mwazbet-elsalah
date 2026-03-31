import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mwazbet_elsalah/constants.dart';
import 'package:mwazbet_elsalah/features/home/presentation/controller/prayer_time_cubit.dart';

class CurrentDate extends StatelessWidget {
  const CurrentDate({super.key});
  @override
  Widget build(BuildContext context) {
    DateTime currentDate = context.read<PrayerTimeCubit>().selectedDate;
    String formattedDate = DateFormat('EEEE, d MMM yyyy').format(currentDate);

    return Text(formattedDate, style: Style.text12Grey(context));
  }
}
