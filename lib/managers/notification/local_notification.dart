import 'package:beat_flutter/managers/logger/beat_logger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
        channelDescription: 'valid normal_channel channel',
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
}
