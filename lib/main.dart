import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';
import 'business/user_bloc.dart';
import 'data/provider/prefs_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  PrefsProvider.init();
  await dotenv.load(fileName: "assets/config/.env");
  UserBloc().add(Init());

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ko')],
      fallbackLocale: const Locale('en'),
      path: 'assets/translations',
      child: const App(),
    ),
  );
}
