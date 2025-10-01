import 'dart:developer';

import 'package:beat_flutter/components/init/init_page.dart';
import 'package:beat_flutter/components/sign_in/sign_in_screen.dart';
import 'package:beat_flutter/managers/permission/permission_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  @override
  Widget build(BuildContext context) {
    return CustomThemeApp(
      child: BlocProvider(
        create: (context) => UserController(),
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
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
            // darkTheme: ThemeData.dark(),
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            navigatorKey: NavigatorKeyManager().navigatorKey,
            onGenerateRoute: Routes.onGenerateRoute,
            home: InitPage(),
            // initialRoute: RouteNames.signIn,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    PermissionManager.requestNotificationPermission();
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
        // Get.find<PedometerController>().stopBackgroundService();
        // Get.find<LocationController>().stopBackgroundService();
        PermissionManager.updateLocationAndActivityPemission();
        App.isForeground = true;
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        App.isForeground = false;
        break;
      default:
        break;
    }
  }
}
