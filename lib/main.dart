import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';
import 'managers/prefs/prefs_manager.dart';

// TODO : 전체적으로 리팩토링 한 번 싹 조져주기
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PrefsManager.init();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: "assets/config/.env");

  // UserBloc().add(Init());

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
}
