import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mwazbet_elsalah/constants.dart';
import 'package:mwazbet_elsalah/core/data/services/location_service.dart';
import 'package:mwazbet_elsalah/core/utils/app_background.dart';
import 'package:mwazbet_elsalah/core/utils/widgets/family_bottom_sheet.dart';
import 'package:mwazbet_elsalah/core/utils/widgets/loading.dart';
import 'package:mwazbet_elsalah/features/auth/presentation/controller/auth_cubit.dart';
import 'package:mwazbet_elsalah/features/family/presentation/view/family_view.dart';
import 'package:mwazbet_elsalah/features/home/presentation/controller/prayer_time_cubit/prayer_time_cubit.dart';
import 'package:mwazbet_elsalah/features/home/presentation/widgets/check_box_list_tile_container.dart';
import 'package:mwazbet_elsalah/features/home/presentation/widgets/current_date.dart';
import 'package:mwazbet_elsalah/features/home/presentation/widgets/next_prayer_container.dart';
import 'package:mwazbet_elsalah/features/home/presentation/widgets/next_prayer_data.dart';
import 'package:mwazbet_elsalah/features/home/presentation/widgets/prayer_azan_notification.dart';
import 'package:mwazbet_elsalah/features/home/presentation/widgets/user_location.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final authCubit = context.read<AuthCubit>();
    final prayerCubit = context.read<PrayerTimeCubit>();

    await authCubit.getCurrentUser();
    final authState = authCubit.state;

    String city = 'Suez';

    if (authState is AuthSuccess) {
      final cityFromFirebase = authState.user.city.trim();

      if (cityFromFirebase.isNotEmpty) {
        city = cityFromFirebase;
      }
    }

    log('CITY FROM INIT: $city');

    await prayerCubit.fetchPrayerTimes(city: city);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AppBackground(),
          BlocBuilder<PrayerTimeCubit, PrayerTimeState>(
            builder: (context, state) {
              if (state is PrayerTimeLoading) {
                return const PrayerLoadingView();
              }

              if (state is PrayerTimeFailure) {
                return Center(child: Text(state.errorMessage));
              }

              if (state is PrayerTimeSuccess) {
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const UserLocation(),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    final city = await LocationService()
                                        .getCity();

                                    log('CITY FROM LOCATION SERVICE: $city');

                                    await context
                                        .read<PrayerTimeCubit>()
                                        .getCity(city);
                                  },
                                  icon: Icon(
                                    Icons.location_on,
                                    color: kPrimaryColor,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          const AzanNotificationDialog(),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.notifications,
                                    color: kPrimaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const CurrentDate(),
                        const Spacer(flex: 1),
                        const Stack(
                          alignment: Alignment.center,
                          children: [NextPrayerContainer(), NextPrayerData()],
                        ),
                        const SizedBox(height: 20),
                        CheckBoxListTileContainer(
                          prayerEntity: state.prayerTimeEntity,
                        ),
                        const Spacer(flex: 2),
                      ],
                    ),
                  ),
                );
              }

              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
