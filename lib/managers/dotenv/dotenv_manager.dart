import 'package:flutter_dotenv/flutter_dotenv.dart';

class DotEnvManager {
  static final DotEnvManager _instance = DotEnvManager._internal();

  factory DotEnvManager() {
    return _instance;
  }

  DotEnvManager._internal();

  Future<void> init() async {
    await dotenv.load(fileName: "assets/config/.env");
  }

  String get rankListUrl => dotenv.env['RANK'] ?? "";
}