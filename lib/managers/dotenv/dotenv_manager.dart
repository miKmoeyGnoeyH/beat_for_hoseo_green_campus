import 'package:flutter_dotenv/flutter_dotenv.dart';

class DotEnvManager {
  static final DotEnvManager _instance = DotEnvManager._internal();

  factory DotEnvManager() {
    return _instance;
  }

  DotEnvManager._internal();

  Future<void> init() async {
    const currentEnv =
        String.fromEnvironment('ENV', defaultValue: 'development');
    const envFile = currentEnv == 'production'
        ? 'assets/config/.env.production'
        : 'assets/config/.env.development';

    await dotenv.load(fileName: envFile);
  }

  String get rankListUrl => dotenv.env['RANK'] ?? "";
  String get walkHistoryUrl => dotenv.env['WALK_HISTORY'] ?? "";
  String get walkRecordUrl => dotenv.env['WALK_RECORD'] ?? "";
}
