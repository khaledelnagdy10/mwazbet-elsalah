import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mwazbet_elsalah/core/view/my_main_navigator.dart';

class AnimatedSplashView extends StatefulWidget {
  const AnimatedSplashView({super.key});

  @override
  State<AnimatedSplashView> createState() => _AnimatedSplashViewState();
}

class _AnimatedSplashViewState extends State<AnimatedSplashView>
    with TickerProviderStateMixin {
  late AnimationController controller;

  late Animation<double> fade;
  late Animation<double> mosqueSlide;
  late Animation<double> logoScale;
  late Animation<double> glowSwing;
  late Animation<double> flowersFade;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );

    fade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));

    mosqueSlide = Tween<double>(
      begin: -80,
      end: 0,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutCubic));

    logoScale = Tween<double>(
      begin: 0.55,
      end: 1,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.elasticOut));

    glowSwing = Tween<double>(
      begin: -0.08,
      end: 0.08,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

    flowersFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.45, 1, curve: Curves.easeIn),
      ),
    );

    controller.forward();

    Timer(const Duration(seconds: 4), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationView()),
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/splash/Rectangle 1.png',
                  fit: BoxFit.cover,
                ),
              ),

              Positioned(
                top: 105 + mosqueSlide.value,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: fade.value,
                  child: Image.asset(
                    'assets/images/splash/Mosque-01 1.png',
                    width: size.width * 0.75,
                  ),
                ),
              ),

              Positioned(
                top: 170,
                right: 34,
                child: Transform.rotate(
                  angle: glowSwing.value,
                  child: Opacity(
                    opacity: fade.value,
                    child: Image.asset(
                      'assets/images/splash/Glow.png',
                      height: 115,
                    ),
                  ),
                ),
              ),

              Positioned(
                right: 0,
                bottom: 20,
                child: Opacity(
                  opacity: flowersFade.value,
                  child: Image.asset(
                    'assets/images/splash/Shape-04 1.png',
                    width: 120,
                  ),
                ),
              ),

              Positioned(
                left: 0,
                bottom: 20,
                child: Opacity(
                  opacity: flowersFade.value,
                  child: Image.asset(
                    'assets/images/splash/Shape-07 1.png',
                    width: 120,
                  ),
                ),
              ),

              Center(
                child: Transform.scale(
                  scale: logoScale.value,
                  child: Opacity(
                    opacity: fade.value,
                    child: Image.asset(
                      'assets/images/splash/OBJECTS.png',
                      width: 165,
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 0,
                right: 0,
                bottom: 90,
                child: Opacity(
                  opacity: fade.value,
                  child: const Text(
                    'Mwazbet El Salah',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFD8B76A),
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
