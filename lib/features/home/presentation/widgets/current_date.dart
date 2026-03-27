import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mwazbet_elsalah/constants.dart';

class CurrentDate extends StatelessWidget {
  const CurrentDate({super.key});
  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('d MMMM yyyy').format(currentDate);

    return Text(formattedDate, style: Style.text12Grey(context));
  }
}
