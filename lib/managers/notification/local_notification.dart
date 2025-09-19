import 'package:beat_flutter/managers/logger/beat_logger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/browser.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

abstract class LocalNotificationManager {
  LocalNotificationManager._internal();

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInitializationSettings =
    DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        BEATLogger.d("LocalNotificationManager - onDidReceiveNotificationResponse : ${notificationResponse.payload}");
      },
    );
  }

  static Future<void> showValidAreaNotification(String title, String body) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        'valid_area_channel',
        'valid_area_channel',
        channelDescription: 'valid area channel',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: DarwinNotificationDetails(badgeNumber: 0),
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  static Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        'normal_channel',
        'normal_channel',
        channelDescription: 'normal channel',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: DarwinNotificationDetails(badgeNumber: 0),
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  static Future<void> setPeriodicalNotification(int id, String title, String body, RepeatInterval interval) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        'periodic_channel',
        'periodic_channel',
        channelDescription: 'periodic channel',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: DarwinNotificationDetails(badgeNumber: 0),
    );

    await flutterLocalNotificationsPlugin.periodicallyShow(
      id,
      title,
      body,
      interval,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exact
    );
  }

  static Future<void> setScheduledNotification(int id, String title, String body, DateTime scheduledDate) async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));

    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        'scheduled_channel',
        'scheduled_channel',
        channelDescription: 'scheduled channel',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: DarwinNotificationDetails(badgeNumber: 0),
    );

    // await flutterLocalNotificationsPlugin.zonedSchedule(
    //   id,
    //   title,
    //   body,
    //   androidScheduleMode:
    //   matchDateTimeComponents: DateTimeComponents.time,
    // );

  }
}
