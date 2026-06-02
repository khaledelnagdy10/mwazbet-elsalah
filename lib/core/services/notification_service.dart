import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _azanChannelId = 'azan_channel';
  static const String _azanChannelName = 'أوقات الصلاة';

  static Future<void> init() async {
    tz.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _plugin.initialize(settings: initSettings);

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestExactAlarmsPermission();
  }

  static Future<void> schedulePrayer({
    required int id,
    required String prayerName,
    required DateTime prayerTime,
  }) async {
    final scheduledTime = tz.TZDateTime.from(prayerTime, tz.local);

    if (scheduledTime.isBefore(tz.TZDateTime.now(tz.local))) return;

    const androidDetails = AndroidNotificationDetails(
      _azanChannelId,
      _azanChannelName,
      channelDescription: 'إشعارات أوقات الصلاة مع الأذان',
      importance: Importance.max,
      priority: Priority.max,
      sound: RawResourceAndroidNotificationSound('azan'),
      playSound: true,
      enableVibration: true,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
      visibility: NotificationVisibility.public,
      audioAttributesUsage: AudioAttributesUsage.alarm,
      timeoutAfter: 60000,
    );

    const iosDetails = DarwinNotificationDetails(
      sound: 'azan.mp3',
      presentSound: true,
      presentAlert: true,
      presentBadge: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.zonedSchedule(
      id: id,
      title: 'حان وقت صلاة $prayerName',
      body: 'اضغط لفتح التطبيق',
      scheduledDate: scheduledTime,
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: prayerName,
    );
  }

  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  static Future<void> cancel(int id) async {
    await _plugin.cancel(id: id);
  }
}
