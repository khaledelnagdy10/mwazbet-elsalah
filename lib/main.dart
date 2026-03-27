import 'package:dio/dio.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mwazbet_elsalah/features/home/data/api/api.dart';
import 'package:mwazbet_elsalah/features/home/data/repo/prayer_time_repo_imp.dart';
import 'package:mwazbet_elsalah/features/home/domain/use_cases/get_next_prayer.dart';
import 'package:mwazbet_elsalah/features/home/domain/use_cases/get_prayer_time.dart';
import 'package:mwazbet_elsalah/features/home/presentation/controller/prayer_time_cubit.dart';
import 'package:mwazbet_elsalah/features/home/presentation/view/home_view.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PrayerTimeCubit(
        getPrayerTime: GetPrayerTime(
          prayerTimeRepo: PrayerTimeRepoImp(api: Api(dio: Dio())),
        ),
        getNextPrayer: GetNextPrayer(),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        theme: FlexThemeData.light(
          scheme: FlexScheme.green,
          useMaterial3: true,
          scaffoldBackground: Colors.grey[100],
          appBarStyle: FlexAppBarStyle.background,
        ),
        darkTheme: FlexThemeData.dark(
          scheme: FlexScheme.green,
          useMaterial3: true,
        ),

        themeMode: ThemeMode.system,

        home: HomeView(),
      ),
    );
  }
}
