import 'package:BEAT/widgets/global/custom_theme_app.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'business/user_bloc.dart';
import 'data/models/user_model.dart';
import 'pages/home_page.dart';
import 'pages/routes/navigator_key_manager.dart';
import 'pages/routes/routes.dart';
import 'pages/settings_page.dart';
import 'pages/sign_in_page.dart';

class App extends StatefulWidget {
  static bool isForeground = true;

  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  final UserBloc _userBloc = UserBloc();

  @override
  Widget build(BuildContext context) {
    return CustomThemeApp(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        navigatorKey: NavigatorKeyManager().navigatorKey,
        routes: {
          Routes.home: (context) => HomePage(),
          Routes.signIn: (context) => SignInPage(),
          Routes.settings: (context) => SettingsPage(),
        },
        initialRoute: user.userPageRoute,
      ),
    );
  }

  User get user => _userBloc.state;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('didChangeAppLifecycleState: $state');
    switch (state) {
      case AppLifecycleState.resumed:
        App.isForeground = true;
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        App.isForeground = false;
        break;
      case AppLifecycleState.detached:
      default:
        break;
    }
    super.didChangeAppLifecycleState(state);
  }
}
