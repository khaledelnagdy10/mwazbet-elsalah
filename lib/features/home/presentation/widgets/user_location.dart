import 'package:flutter/material.dart';
import 'package:mwazbet_elsalah/constants.dart';

class UserLocation extends StatelessWidget {
  const UserLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return Text('Suez, Egypt', style: Style.userLocationTextStyle(context));
  }
}
