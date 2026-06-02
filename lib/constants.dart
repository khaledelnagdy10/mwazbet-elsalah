import 'package:flutter/material.dart';

final kPrimaryColor = const Color.fromARGB(
  255,
  47,
  79,
  48,
); // Color(0xFF1B4332); --- IGNORE ---
final kTextDarkColor = Color(0xFF202020);
final kBorderColor = Color(0xFFE6E6E6);
final Color blueLink = Color(0xFF4C63D2);

abstract class Style {
  static TextStyle kPrimaryTextColor(BuildContext context) {
    return TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: kPrimaryColor,
    );
  }

  static TextStyle text12Grey(BuildContext context) {
    return TextStyle(
      fontSize: 12,
      color: const Color(0xFF6B705C).withOpacity(0.9),
    );
  }

  static TextStyle text14Grey(BuildContext context) {
    return TextStyle(
      fontSize: 14,
      color: const Color(0xFF6B705C).withOpacity(0.95),
    );
  }

  static TextStyle text14Black(BuildContext context) {
    return TextStyle(
      fontSize: 14,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle text16Black(BuildContext context) {
    return TextStyle(
      fontSize: 16,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle bold16Black(BuildContext context) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle bold20White(BuildContext context) {
    return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static const TextStyle bold20AllWhite = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle bold30White(BuildContext context) {
    return TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static const TextStyle bold30AllWhite = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}
