import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mwazbet_elsalah/features/home/presentation/controller/prayer_time_cubit.dart';

class CustomNavigatorBar extends StatefulWidget {
  const CustomNavigatorBar({super.key});

  @override
  State<CustomNavigatorBar> createState() => _CustomNavigatorBarState();
}

class _CustomNavigatorBarState extends State<CustomNavigatorBar> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final selectedDate = context.watch<PrayerTimeCubit>().selectedDate;

    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.transparent.withOpacity(0.02),
        borderRadius: BorderRadius.circular(12),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = constraints.maxWidth / 3;
          const indicatorWidth = 60.0;

          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                left:
                    currentIndex * itemWidth +
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

              // 👇 العناصر
              Row(
                children: [
                  _buildItem(
                    index: 0,
                    iconSelected: 'assets/images/islamic.png',
                    iconUnselected: 'assets/images/pray.png',
                    label: "Home",
                    onTap: () {
                      setState(() {
                        currentIndex = 0;
                      });
                    },
                  ),
                  _buildItem(
                    index: 1,
                    iconSelected: 'assets/images/calendar.png',
                    iconUnselected: 'assets/images/calendar.png',
                    label: "Calendar",
                    onTap: () async {
                      setState(() {
                        currentIndex = 1;
                      });

                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );

                      if (pickedDate != null) {
                        context.read<PrayerTimeCubit>().changeDate(pickedDate);

                        log("Selected date: $pickedDate");
                      }

                      setState(() {
                        currentIndex = 0;
                      });
                    },
                  ),
                  _buildItem(
                    index: 2,
                    iconSelected: 'assets/images/user.png',
                    iconUnselected: 'assets/images/people.png',
                    label: "Profile",
                    onTap: () {
                      setState(() {
                        currentIndex = 2;
                      });
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildItem({
    required int index,
    required String iconSelected,
    required String iconUnselected,
    required String label,
    required VoidCallback onTap,
  }) {
    final isSelected = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 7),
            Image.asset(
              isSelected ? iconSelected : iconUnselected,
              width: isSelected ? 30 : 26,
              height: isSelected ? 30 : 26,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: isSelected ? 13 : 11,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
