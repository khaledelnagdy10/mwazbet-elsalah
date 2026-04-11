import 'package:flutter/material.dart';
import 'package:mwazbet_elsalah/constants.dart';

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: kTextDarkColor,
      ),
    );
  }
}
