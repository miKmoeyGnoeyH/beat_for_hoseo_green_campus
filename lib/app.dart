import 'package:beat_flutter/pages/home_page.dart';
import 'package:beat_flutter/pages/sign_in_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'business/user_bloc.dart';
import 'data/models/user_model.dart';
import 'pages/routes/navigator_key_manager.dart';
import 'pages/routes/routes.dart';
import 'theme/theme_factory.dart';


class App extends StatefulWidget {
  static bool isForeground = true;

  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  final UserBloc _userBloc = UserBloc();
  ThemeData theme = ThemeFactory.getThemeDataDependsOnSystemBrightness;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      theme: theme,
      navigatorKey: NavigatorKeyManager().navigatorKey,
      routes: {
        Routes.home: (context) => HomePage(),
        Routes.signIn: (context) => SignInPage(),
      },
      initialRoute: user.userPageRoute,
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
  void didChangePlatformBrightness() {
    debugPrint('didChangePlatformBrightness');
    setState(() {
      theme = ThemeFactory.getThemeDataDependsOnSystemBrightness;
    });
    super.didChangePlatformBrightness();
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