import 'dart:developer';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mwazbet_elsalah/features/home/presentation/controller/prayer_time_cubit/prayer_time_cubit.dart';

class CustomNavigatorBar extends StatelessWidget {
  const CustomNavigatorBar({
    super.key,
    required this.currentIndex,
    required this.onItemTap,
  });

  final int currentIndex;
  final Function(int) onItemTap;

  @override
  Widget build(BuildContext context) {
    final selectedDate = context.watch<PrayerTimeCubit>().selectedDate;
    final isArabic = context.locale.languageCode == 'ar';

    return SizedBox(
      height: 80,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/image (2).png',
                  fit: BoxFit.cover,
                ),
              ),

              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(color: Colors.black.withOpacity(0.35)),
                ),
              ),

              LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = constraints.maxWidth / 5;
                  const indicatorWidth = 50.0;

                  final displayedIndex = isArabic
                      ? 4 - currentIndex
                      : currentIndex;

                  return Stack(
                    children: [
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        left:
                            displayedIndex * itemWidth +
                            (itemWidth / 2) -
                            (indicatorWidth / 2),
                        top: 4,
                        child: Container(
                          width: indicatorWidth,
                          height: 2,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      Row(
                        children: [
                          /// HOME
                          _buildItem(
                            context: context,
                            index: 0,
                            iconSelected: 'assets/images/islamic.png',
                            iconUnselected: 'assets/images/pray.png',
                            label: 'Home',
                            onTap: () {
                              onItemTap(0);
                            },
                            selectedSize: 30,
                            unselectedSize: 27,
                          ),

                          /// CALENDAR
                          _buildItem(
                            context: context,
                            index: 1,
                            iconSelected: 'assets/images/calendar.png',
                            iconUnselected: 'assets/images/calendar.png',
                            label: 'Calendar',
                            onTap: () async {
                              onItemTap(1);

                              final pickedDate =
                                  await showGeneralDialog<DateTime>(
                                    context: context,
                                    barrierDismissible: true,
                                    barrierLabel: 'Calendar'.tr(),
                                    barrierColor: Colors.black.withOpacity(0.4),
                                    transitionDuration: const Duration(
                                      milliseconds: 350,
                                    ),
                                    pageBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                        ) {
                                          return Center(
                                            child: Material(
                                              color: Colors.transparent,
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                    ),
                                                padding: const EdgeInsets.all(
                                                  10,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(
                                                    context,
                                                  ).scaffoldBackgroundColor,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: CalendarDatePicker(
                                                  initialDate: selectedDate,
                                                  firstDate: DateTime(2000),
                                                  lastDate: DateTime(2100),
                                                  onDateChanged: (date) {
                                                    Navigator.pop(
                                                      context,
                                                      date,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                    transitionBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                          child,
                                        ) {
                                          return ScaleTransition(
                                            scale: CurvedAnimation(
                                              parent: animation,
                                              curve: Curves.easeOutBack,
                                            ),
                                            child: FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            ),
                                          );
                                        },
                                  );

                              if (pickedDate != null) {
                                context.read<PrayerTimeCubit>().changeDate(
                                  pickedDate,
                                );

                                log('Selected date: $pickedDate');
                              }

                              onItemTap(0);
                            },
                            selectedSize: 24,
                            unselectedSize: 22,
                          ),

                          /// QIBLA
                          _buildItem(
                            context: context,
                            index: 2,
                            iconSelected: 'assets/images/qibla-compass.png',
                            iconUnselected: 'assets/images/qibla (2).png',
                            label: 'Qibla',
                            onTap: () {
                              onItemTap(2);
                            },
                            selectedSize: 30,
                            unselectedSize: 24,
                          ),

                          /// FAMILY
                          _buildItem(
                            context: context,
                            index: 3,
                            iconSelected: 'assets/images/family.png',
                            iconUnselected: 'assets/images/parents.png',
                            label: 'Family',
                            onTap: () {
                              onItemTap(3);
                            },
                            selectedSize: 26,
                            unselectedSize: 28,
                          ),

                          /// PROFILE
                          _buildItem(
                            context: context,
                            index: 4,
                            iconSelected: 'assets/images/user.png',
                            iconUnselected: 'assets/images/people.png',
                            label: 'Profile',
                            onTap: () {
                              onItemTap(4);
                            },
                            selectedSize: 26,
                            unselectedSize: 22,
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem({
    required BuildContext context,
    required int index,
    required String iconSelected,
    required String iconUnselected,
    required String label,
    required VoidCallback onTap,
    required double selectedSize,
    required double unselectedSize,
  }) {
    final isSelected = currentIndex == index;

    final double iconSize = isSelected ? selectedSize : unselectedSize;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 7),

            SizedBox(
              width: 32,
              height: 32,
              child: Center(
                child: Image.asset(
                  isSelected ? iconSelected : iconUnselected,
                  width: iconSize,
                  height: iconSize,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                ),
              ),
            ),

            const SizedBox(height: 4),

            Text(
              label.tr(),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: isSelected ? 13 : 11,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
