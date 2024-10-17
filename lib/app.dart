import 'package:BEAT/widgets/global/custom_theme_app.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'business/user_bloc.dart';
import 'data/models/user_model.dart';
import 'managers/navigator/routes.dart';
import 'widgets/home/home_screen.dart';
import 'managers/navigator/navigator_key_manager.dart';
import 'widgets/register/register_affiliation_screen.dart';
import 'widgets/settings/settings_screen.dart';
import 'widgets/sign_in/sign_in_screen.dart';

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
          Routes.home: (context) => HomeScreen(),
          Routes.signIn: (context) => SignInScreen(),
          Routes.settings: (context) => SettingsScreen(),
          Routes.register: (context) => RegisterAffiliationScreen(),
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
