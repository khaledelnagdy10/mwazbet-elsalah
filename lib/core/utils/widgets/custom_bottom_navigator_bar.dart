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
    return BottomNavigationBar(
      backgroundColor: Colors.transparent.withOpacity(0.6),
      elevation: 0,
      currentIndex: currentIndex,
      onTap: (index) async {
        if (index == 1) {
          setState(() {
            currentIndex = index;
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
          return;
        }
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(
            currentIndex == 0
                ? 'assets/images/islamic.png'
                : 'assets/images/pray.png',
            width: currentIndex == 0 ? 30 : 28,
            height: currentIndex == 0 ? 30 : 28,
            color: currentIndex == 0
                ? Theme.of(context).colorScheme.primary
                : Colors.grey,
          ),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/calendar.png',
            width: currentIndex == 1 ? 28 : 21,
            height: currentIndex == 1 ? 28 : 21,
            color: currentIndex == 1
                ? Theme.of(context).colorScheme.primary
                : Colors.grey,
          ),

          label: "Calendar",
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/user.png',
            width: currentIndex == 2 ? 26 : 23,
            height: currentIndex == 2 ? 26 : 23,
            color: currentIndex == 2
                ? Theme.of(context).colorScheme.primary
                : Colors.grey,
          ),

          label: "Profile",
        ),
      ],
    );
    // return CurvedNavigationBar(
    //   backgroundColor: Colors.transparent,
    //   items: [
    //     Icon(Icons.home, size: 30, color: Colors.black),
    //     Icon(Icons.calendar_today, size: 30, color: Colors.black),
    //     Icon(Icons.settings, size: 30, color: Colors.black),
    //   ],
    //   animationDuration: const Duration(milliseconds: 350),
    // );

    //   return Padding(
    //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    //     child: ClipRRect(
    //       borderRadius: BorderRadius.circular(40),
    //       child: BackdropFilter(
    //         filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
    //         child: Container(
    //           height: 75,
    //           decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(40),

    //             // 🌈 Glass effect
    //             gradient: LinearGradient(
    //               begin: Alignment.topLeft,
    //               end: Alignment.bottomRight,
    //               colors: [
    //                 Colors.white.withOpacity(0.25),
    //                 Colors.green.withOpacity(0.15),
    //               ],
    //             ),

    //             // ✨ border خفيف
    //             border: Border.all(
    //               color: Colors.white.withOpacity(0.3),
    //               width: 1.2,
    //             ),

    //             // 🔥 glow
    //             boxShadow: [
    //               BoxShadow(
    //                 color: Colors.green.withOpacity(0.4),
    //                 blurRadius: 25,
    //                 spreadRadius: 1,
    //                 offset: const Offset(0, 10),
    //               ),
    //             ],
    //           ),
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceAround,
    //             children: [
    //               _buildItem(Icons.home, 0),
    //               _buildItem(Icons.calendar_today, 1),
    //               _buildItem(Icons.settings, 2),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //   );
    // }

    // Widget _buildItem(IconData icon, int index) {
    //   bool isSelected = currentIndex == index;

    //   return GestureDetector(
    //     onTap: () {
    //       setState(() {
    //         currentIndex = index;
    //       });
    //     },
    //     child: AnimatedSwitcher(
    //       duration: const Duration(milliseconds: 300),
    //       transitionBuilder: (child, animation) {
    //         return ScaleTransition(
    //           scale: animation,
    //           child: FadeTransition(opacity: animation, child: child),
    //         );
    //       },
    //       child: Icon(
    //         icon,
    //         key: ValueKey(isSelected),
    //         size: isSelected ? 30 : 24,
    //         color: isSelected
    //             ? Theme.of(context).colorScheme.primary
    //             : Colors.white70,
    //       ),
    //     ),
    //   );
  }
}
