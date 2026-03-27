import 'package:flutter/material.dart';
import 'package:mwazbet_elsalah/constants.dart';

class NextPrayerData extends StatelessWidget {
  const NextPrayerData({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Positioned(
          child: Text('Next Prayer', style: Style.bold20AllWhite(context)),
        ),
        Divider(color: Colors.grey, thickness: 1, indent: 125, endIndent: 125),
        Text('ASR', style: Style.bold30AllWhite(context)),
        Text('3:30:20', style: Style.bold30AllWhite(context)),
      ],
    );
  }
}
