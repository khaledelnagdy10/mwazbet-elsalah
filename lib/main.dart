import 'package:dio/dio.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mwazbet_elsalah/features/auth/presentation/view/auth_view.dart';
import 'package:mwazbet_elsalah/features/home/data/api/api.dart';
import 'package:mwazbet_elsalah/features/home/data/repo/prayer_time_repo_imp.dart';
import 'package:mwazbet_elsalah/features/home/domain/use_cases/get_next_prayer.dart';
import 'package:mwazbet_elsalah/features/home/domain/use_cases/get_prayer_time.dart';
import 'package:mwazbet_elsalah/features/home/domain/use_cases/get_remaining_time.dart';
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
        getRemainingTime: GetRemainingTimeUseCase(),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        theme: FlexThemeData.light(
          useMaterial3: true,
          colors: const FlexSchemeColor(
            primary: Color(0xFF1B4332),
            primaryContainer: Color(0xFFDCE9E2),
            secondary: Color(0xFFD4A373),
            secondaryContainer: Color(0xFFF4E6D7),
            tertiary: Color(0xFF6B705C),
            tertiaryContainer: Color(0xFFEAE7DC),
            appBarColor: Color(0xFFF8F4EE),
            error: Color(0xFFB3261E),
          ),
          scaffoldBackground: const Color(0xFFF8F4EE),
          surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
          blendLevel: 8,
          appBarStyle: FlexAppBarStyle.background,
          subThemesData: const FlexSubThemesData(
            defaultRadius: 16,
            inputDecoratorRadius: 14,
            inputDecoratorBorderType: FlexInputBorderType.outline,
            elevatedButtonRadius: 16,
            cardRadius: 20,
            dialogRadius: 20,
            bottomNavigationBarElevation: 0,
          ),
        ),
        darkTheme: FlexThemeData.dark(
          useMaterial3: true,
          colors: const FlexSchemeColor(
            primary: Color(0xFFB7D6C5),
            primaryContainer: Color(0xFF1B4332),
            secondary: Color(0xFFD4A373),
            secondaryContainer: Color(0xFF6B4F3A),
            tertiary: Color(0xFFDAD7CD),
            tertiaryContainer: Color(0xFF344E41),
            appBarColor: Color(0xFF0F1E18),
            error: Color(0xFFF2B8B5),
          ),
          scaffoldBackground: const Color(0xFF0F1E18),
          surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
          blendLevel: 10,
          appBarStyle: FlexAppBarStyle.background,
          subThemesData: const FlexSubThemesData(
            defaultRadius: 16,
            inputDecoratorRadius: 14,
            inputDecoratorBorderType: FlexInputBorderType.outline,
            elevatedButtonRadius: 16,
            cardRadius: 20,
            dialogRadius: 20,
            bottomNavigationBarElevation: 0,
          ),
        ),
        themeMode: ThemeMode.system,

        home: AuthView(),
      ),
    );
  }
}
