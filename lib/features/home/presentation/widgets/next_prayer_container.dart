import 'package:flutter/material.dart';

class NextPrayerContainer extends StatelessWidget {
  const NextPrayerContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            // color: kPrimaryColor.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox.expand(
          child: Image.asset(
            "assets/images/Untitled design.png",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
