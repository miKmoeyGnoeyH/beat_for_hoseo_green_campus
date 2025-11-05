import 'dart:developer';
import 'dart:convert';
import 'dart:io';

import 'package:beat_flutter/controller/location/location_controller.dart';
import 'package:beat_flutter/controller/screen_holder/page_index_controller.dart';
import 'package:beat_flutter/managers/dotenv/dotenv_manager.dart';
import 'package:beat_flutter/managers/logger/beat_logger.dart';
import 'package:beat_flutter/managers/notification/local_notification.dart';
import 'package:beat_flutter/managers/package_info/package_info_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart' hide Trans;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'controller/pedometer/pedometer_controller.dart';
import 'controller/activity_service_controller.dart';
import 'firebase_options.dart';
import 'managers/prefs/prefs_manager.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // 중복 수신 가드: 동일 메시지 ID는 짧은 시간 내 한 번만 처리
  try {
    final prefs = await SharedPreferences.getInstance();
    final String currentId = message.messageId ??
        (message.data['messageId']?.toString() ?? message.data.toString());
    final String lastId = prefs.getString('last_fcm_id') ?? '';
    final int lastAt = prefs.getInt('last_fcm_at') ?? 0;
    final int nowMs = DateTime.now().millisecondsSinceEpoch;
    // 30초 이내 동일 ID 재수신 시 무시
    if (currentId == lastId && nowMs - lastAt < 30000) {
      return;
    }
    await prefs.setString('last_fcm_id', currentId);
    await prefs.setInt('last_fcm_at', nowMs);
  } catch (_) {}

  if (message.notification != null) {
    log('main.dart : _firebaseMessagingBackgroundHandler() : message.notification.title : ${message.notification!.title.toString()}');
    log('main.dart : _firebaseMessagingBackgroundHandler() : message.notification.body : ${message.notification!.body.toString()}');
  }

  final String msg = message.data["message"];

  if (Platform.isAndroid) {
    if (msg == "0") {
      FlutterBackgroundService().invoke("midnightReset");
    } else {
      FlutterBackgroundService().invoke("addWalkReport");
    }
    return;
  }

  if (Platform.isIOS) {
    log("iOS: Background Message Received");
    
    const MethodChannel _locationChannel = MethodChannel("com.beat.walkreport/location");

    if (msg == "0") {
      _locationChannel.invokeMethod("midnightReset");
    } else {
      _locationChannel.invokeMethod("syncWalkDataInBackground");
    }
  }
}

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await BEATLogger.init();
  await PrefsManager().init();
  await LocalNotificationManager.init();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await EasyLocalization.ensureInitialized();
  await DotEnvManager().init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    log('main.dart : main() : message.data : ${message.data.toString()}');
    if (message.notification != null) {
      log('main.dart : main() : message.notification.title : ${message.notification!.title.toString()}');
      log('main.dart : main() : message.notification.body : ${message.notification!.body.toString()}');
    }
    Get.find<ActivityServiceController>().addWalkReport();
  });

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (Platform.isIOS) {
    String? apnsToken = await messaging.getAPNSToken();
    if (apnsToken != null) {
    } else {
      await Future<void>.delayed(
        const Duration(
          seconds: 3,
        ),
      );
      apnsToken = await messaging.getAPNSToken();
    }
    log('APNs token: $apnsToken');
  }

  PackageInfoManager.instance.init();

  final PedometerController pedometerController =
      Get.put<PedometerController>(PedometerController(), permanent: true);

  final LocationController locationController =
      Get.put<LocationController>(LocationController(), permanent: true);

  final ActivityServiceController activityServiceController =
      Get.put<ActivityServiceController>(ActivityServiceController(),
          permanent: true);

  await activityServiceController.initializeService();

  Get.put(PageIndexController(), permanent: true);

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('ko'),
      ],
      fallbackLocale: const Locale('en'),
      path: 'assets/translations',
      child: const App(),
    ),
  );

  // FlutterNativeSplash.remove();
}
