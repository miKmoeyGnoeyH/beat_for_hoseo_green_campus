 import 'dart:developer';
import 'dart:io';

import 'package:beat_flutter/controller/location/location_controller.dart';
import 'package:beat_flutter/managers/dotenv/dotenv_manager.dart';
import 'package:beat_flutter/managers/logger/beat_logger.dart';
import 'package:beat_flutter/managers/notification/local_notification.dart';
import 'package:beat_flutter/managers/package_info/package_info_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart' hide Trans;

import 'app.dart';
import 'controller/pedometer/pedometer_controller.dart';
import 'firebase_options.dart';
import 'managers/prefs/prefs_manager.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("main.dart : _firebaseMessagingBackgroundHandler() : message.data : ${message.data}");
  if(message.notification != null) {
    log('main.dart : _firebaseMessagingBackgroundHandler() : message.notification.title : ${message.notification!.title.toString()}');
    log('main.dart : _firebaseMessagingBackgroundHandler() : message.notification.body : ${message.notification!.body.toString()}');
  }
}

 // @pragma('vm:entry-point')
 // void notificationTapBackground(NotificationResponse notificationResponse) {
 //   // handle action
 // }

// TODO : 전체적으로 리팩토링 한 번 싹 조져주기
Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await BEATLogger.init();
  await PrefsManager().init();
  await LocalNotificationManager.init();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await EasyLocalization.ensureInitialized();
  await DotEnvManager().init();

  final PedometerController pedometerController = Get.put<PedometerController>(PedometerController(), permanent: true);
  final LocationController locationController = Get.put<LocationController>(LocationController(), permanent: true);

  pedometerController.initializeService();
  locationController.initializeService();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    log('main.dart : main() : message.data : ${message.data.toString()}');
    if(message.notification != null) {
      log('main.dart : main() : message.notification.title : ${message.notification!.title.toString()}');
      log('main.dart : main() : message.notification.body : ${message.notification!.body.toString()}');
    }
  });

  PackageInfoManager.instance.init();

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

  FlutterNativeSplash.remove();
}
