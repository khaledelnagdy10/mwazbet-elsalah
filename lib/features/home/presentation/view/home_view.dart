import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mwazbet_elsalah/constants.dart';
import 'package:mwazbet_elsalah/core/data/services/location_service.dart';
import 'package:mwazbet_elsalah/core/utils/widgets/custom_bottom_navigator_bar.dart';
import 'package:mwazbet_elsalah/core/utils/widgets/loading.dart';
import 'package:mwazbet_elsalah/features/home/presentation/controller/prayer_time_cubit.dart';
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
    final city = await LocationService().getCity();
    log('City: $city'); // شوف بيطلع إيه في الـ console

    context.read<PrayerTimeCubit>().changeCity(city);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: CustomNavigatorBar(),
      body: BlocBuilder<PrayerTimeCubit, PrayerTimeState>(
        builder: (context, state) {
          if (state is PrayerTimeLoading) {
            return const PrayerLoadingView();
          }
          if (state is PrayerTimeFailure) {
            return Text('Failed to load prayer times');
          }
          if (state is PrayerTimeSuccess) {
            return Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,

                  child: FractionallySizedBox(
                    child: Image.asset(
                      'assets/images/BackGroundStory.jpeg',
                      color: Colors.white.withOpacity(0.1),
                      colorBlendMode: BlendMode.modulate,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),

                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            UserLocation(),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    final city = await LocationService()
                                        .getCity();
                                    context.read<PrayerTimeCubit>().changeCity(
                                      city,
                                    );
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
                                          AzanNotificationDialog(),
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
                        CurrentDate(),
                        Spacer(flex: 1),
                        Stack(
                          alignment: Alignment.center,
                          children: [NextPrayerContainer(), NextPrayerData()],
                        ),
                        SizedBox(height: 20),
                        CheckBoxListTileContainer(
                          prayerEntity: state.prayerTimeEntity,
                        ),

                        Spacer(flex: 2),

                        CustomNavigatorBar(),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
