import 'dart:developer';

import 'package:dio/dio.dart';

class Api {
  final Dio dio;

  Api({required this.dio});

  Future<Map<String, dynamic>> getPrayerTime({required String city}) async {
    try {
      final today = DateTime.now();
      final dateString = '${today.day}-${today.month}-${today.year}';
      Response response = await dio.get(
        'https://api.aladhan.com/v1/timingsByCity/$dateString?city=$city&country=Egypt&method=5',
      );
      log(response.toString());
      return response.data['data']['timings'];
    } catch (e) {
      log('Error occurred while fetching prayer times: $e');
      return {};
    }
  }
}
