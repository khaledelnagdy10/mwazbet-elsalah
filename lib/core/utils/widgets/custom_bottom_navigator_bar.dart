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
    return BottomNavigationBar(
      elevation: 0,
      currentIndex: currentIndex,
      onTap: (index) async {
        if (index == 1) {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );

          if (pickedDate != null) {
              context.read<PrayerTimeCubit>().changeDate(pickedDate);

            log("Selected date: $pickedDate");
          }

          return; 
        }
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            currentIndex == 0 ? Icons.home : Icons.home_outlined,
            size: currentIndex == 0 ? 27 : 22,
          ),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            currentIndex == 1
                ? Icons.calendar_month
                : Icons.calendar_month_outlined,
            size: currentIndex == 1 ? 27 : 22,
          ),
          label: "Calendar",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            currentIndex == 2 ? Icons.person : Icons.person_outline,
            size: currentIndex == 2 ? 27 : 22,
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
