import 'package:flutter_dotenv/flutter_dotenv.dart';

class DotEnvManager {
  static final DotEnvManager _instance = DotEnvManager._internal();
  static const bool _isInitialized = false;

  factory DotEnvManager() {
    return _instance;
  }

  DotEnvManager._internal();

  Future<void> init() async {
    if(_isInitialized) return;

    const currentEnv =
        String.fromEnvironment('ENV', defaultValue: 'development');
    const envFile = currentEnv == 'production'
        ? 'assets/config/.env.production'
        : 'assets/config/.env.development';

    await dotenv.load(fileName: envFile);
  }

  Future<void> ensureInitialized() async {
    if (!_isInitialized) {
      await init();
    }
  }

  String get signIn => dotenv.env['SIGN_IN'] ?? "";
  String get pointHistory => dotenv.env['NEURO_HISTORY'] ?? "";
  String get myPoint => dotenv.env['MY_NEURO'] ?? "";
  String get signUp => dotenv.env['SIGN_UP'] ?? "";
  String get idCheck => dotenv.env['ID_CHECK'] ?? "";
  String get nicknameCheck => dotenv.env['NICKNAME_CHECK'] ?? "";
  String get emailRequest => dotenv.env['EMAIL_REQUEST'] ?? "";
  String get resetPasswordEmailRequest => dotenv.env['RESET_PASSWORD_EMAIL_REQUEST'] ?? "";
  String get resetPasswordPrivate => dotenv.env['RESET_PASSWORD_PRIVATE'] ?? "";
  String get resetPasswordPublic => dotenv.env['RESET_PASSWORD_PUBLIC'] ?? "";
  String get info => dotenv.env['INFO'] ?? "";
  String get infoImage => dotenv.env['INFO_IMAGE'] ?? "";
  String get questList => dotenv.env['QUEST_LIST'] ?? "";
  String get questQRDetailUrl => dotenv.env['QUEST_QR_DETAIL'] ?? "";
  String get questWalkDetailUrl => dotenv.env['QUEST_WALK_DETAIL'] ?? "";
  String get questQRCheckUrl => dotenv.env['QUEST_QR_CHECK'] ?? "";
  String get questWalkCheckUrl => dotenv.env['QUEST_WALK_CHECK'] ?? "";
  String get questImage => dotenv.env['QUEST_IMAGE'] ?? "";
  String get surveyList => dotenv.env['SURVEY_LIST'] ?? "";
  String get surveyDetail => dotenv.env['SURVEY_DETAIL'] ?? "";
  String get surveyAnswer => dotenv.env['SURVEY_ANSWER'] ?? "";
  String get rankListUrl => dotenv.env['RANK'] ?? "";
  String get myRankUrl => dotenv.env['MY_RANK'] ?? "";
  String get notice => dotenv.env['NOTICE_LIST'] ?? "";
  String get walkHistoryUrl => dotenv.env['WALK_HISTORY'] ?? "";
  String get walkRecordUrl => dotenv.env['WALK_RECORD'] ?? "";
  String get withdrawal => dotenv.env['WITHDRAW'] ?? "";
  String get holidayList => dotenv.env['HOLIDAY_LIST'] ?? "";
  String get emailVerify => dotenv.env['EMAIL_VERIFY'] ?? "";
  String get resetPasswordCodeVerify => dotenv.env['RESET_PASSWORD_CODE_VERIFY'] ?? "";
  String get walkMeanHistory => dotenv.env['WALK_MEAN_HISTORY'] ?? "";
}
