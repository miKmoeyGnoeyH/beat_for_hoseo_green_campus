import 'dart:developer';

import 'package:beat_flutter/components/sign_in/sign_in_screen.dart';
import 'package:beat_flutter/controller/location/location_controller.dart';
import 'package:beat_flutter/controller/pedometer/pedometer_controller.dart';
import 'package:beat_flutter/managers/permission/permission_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'components/global/widgets/custom_theme_app.dart';
import 'controller/user_controller.dart';
import 'managers/navigator/routes.dart';
import 'managers/navigator/navigator_key_manager.dart';

class App extends StatefulWidget {
  static bool isForeground = true;

  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  // final List<Permission> permissions = [
  //   Permission.storage,
  //   Permission.camera,
  //   Permission.notification,
  // ];
  //
  // Future<void> requestPermissions() async {
  //   Map<Permission, PermissionStatus> status = await permissions.request();
  //   log(status.map((key, value) => MapEntry(key, value.toString())).toString());
  // }

  final PermissionManager permissionManager = PermissionManager();

  @override
  Widget build(BuildContext context) {
    return CustomThemeApp(
      child: BlocProvider(
        create: (context) => UserController(),
        child: GetMaterialApp(
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.noScaling,
              ),
              child: child!,
            );
          },
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          navigatorKey: NavigatorKeyManager().navigatorKey,
          onGenerateRoute: Routes.onGenerateRoute,
          home: SignInScreen(),
          // initialRoute: RouteNames.signIn,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    permissionManager.requestNotificationPermission();

    setControllerFlags();
  }

  Future<void> setControllerFlags() async {
    final bool isLocationPermissionDenied =
        await PermissionManager().isLocationPermissionDenied();
    final bool isActivityPermissionDenied =
        await PermissionManager.isActivityPermissionDenied();

    final LocationController locationController =
        Get.find<LocationController>();
    final PedometerController pedometerController =
        Get.find<PedometerController>();

    log("app.dart : setControllerFlags : isLocationPermissionDenied : $isLocationPermissionDenied");
    log("app.dart : setControllerFlags : isActivityPermissionDenied : $isActivityPermissionDenied");

    locationController.isLocationPermissionDenied.value =
        isLocationPermissionDenied;
    pedometerController.isActivityPermissionDenied.value =
        isActivityPermissionDenied;
    pedometerController.isLocationPermissionDenied.value =
        isLocationPermissionDenied;

    // log("app.dart : setControllerFlags : locationController.isLocationPermissionDenied : ${locationController.isLocationPermissionDenied}");
    // log("app.dart : setControllerFlags : pedometerController.isLocationPermissionDenied : ${pedometerController.isLocationPermissionDenied.value}");
    // log("app.dart : setControllerFlags : pedometerController.isActivityPermissionDenied : ${pedometerController.isActivityPermissionDenied.value}");
    // log("app.dart : setControllerFlags : pedometerController.isEventDuration : ${pedometerController.isEventDuration.value}");
    // log("app.dart : setControllerFlags : pedometerController.isHoliday : ${pedometerController.isHoliday.value}");
    // log("app.dart : setControllerFlags : pedometerController.isInValidArea : ${pedometerController.isInValidArea.value}");
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    log('app.dart : _handleMessage : ${message.data.toString()}');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    debugPrint('didChangeAppLifecycleState: $state');
    switch (state) {
      case AppLifecycleState.resumed:
        Get.find<PedometerController>().stopBackgroundService();
        Get.find<LocationController>().stopBackgroundService();
        setControllerFlags();
        App.isForeground = true;
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        Get.find<PedometerController>().startBackgroundService();
        Get.find<LocationController>().startBackgroundService();
        App.isForeground = false;
        break;
      default:
        break;
    }
    super.didChangeAppLifecycleState(state);
  }
}
