import 'package:flutter/material.dart';
import 'package:mwazbet_elsalah/core/utils/widgets/custom_bottom_navigator_bar.dart';
import 'package:mwazbet_elsalah/features/family/presentation/view/family_view.dart';
import 'package:mwazbet_elsalah/features/home/presentation/view/home_view.dart';
import 'package:mwazbet_elsalah/features/profile/presentation/view/profile_view.dart';
import 'package:mwazbet_elsalah/features/qibla/presentation/view/qibla_view.dart';

class MainNavigationView extends StatefulWidget {
  const MainNavigationView({super.key});

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomeView(),
    SizedBox(),
    QiblaView(),
    FamilyView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: currentIndex == 1 ? 0 : currentIndex,
        children: pages,
      ),
      bottomNavigationBar: CustomNavigatorBar(
        currentIndex: currentIndex,
        onItemTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
