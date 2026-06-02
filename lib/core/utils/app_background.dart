import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
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
    );
  }
}
