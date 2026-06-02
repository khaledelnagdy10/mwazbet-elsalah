import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

String localizePrayerTime(BuildContext context, String time) {
  String result = time.replaceAll('AM', 'AM'.tr()).replaceAll('PM', 'PM'.tr());

  if (context.locale.languageCode == 'ar') {
    result = result
        .replaceAll('0', '٠')
        .replaceAll('1', '١')
        .replaceAll('2', '٢')
        .replaceAll('3', '٣')
        .replaceAll('4', '٤')
        .replaceAll('5', '٥')
        .replaceAll('6', '٦')
        .replaceAll('7', '٧')
        .replaceAll('8', '٨')
        .replaceAll('9', '٩');
  }

  return result;
}
