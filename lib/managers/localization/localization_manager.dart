
import 'package:easy_localization/easy_localization.dart';

/// [easy_localization] 패키지를 더 간편히 사용하기 위한 클래스.
/// 텍스트가 너무 많아, 추상 클래스에 정적 메소드 방식은 메모리 낭비가 심할 것이라 판단.
/// 싱글톤 + getter 방식으로 구현.
class LocalizationManager {
  static final LocalizationManager _instance = LocalizationManager._internal();
  LocalizationManager._internal();
  factory LocalizationManager() {
    return _instance;
  }

  // home
  String get homePointsInHand => "home".tr(gender: "points_in_hand");
  String get homeTapToCheckYourHistory => "home".tr(gender: "tap_to_check_your_history");
  String get homeQuest => "home".tr(gender: "quest");
  String homeQuestNo(String arg) => "home".tr(gender: "quest_no", args: [arg]);
  String get homeQuiz => "home".tr(gender: "quiz");
  String homeQuizNo(String arg) => "home".tr(gender: "quiz_no", args: [arg]);
  String get homeSurvey => "home".tr(gender: "survey");
  String homeSurveyNo(String arg) => "home".tr(gender: "survey_no", args: [arg]);
  String get homeSurveyDesc => "home".tr(gender: "survey_desc");
  String get homeThereIsNoQuizYet => "home".tr(gender: "there_is_no_quiz_yet");
  String get homeStepCount => "home".tr(gender: "step_count");
  String homeSteps(String arg) => "home".tr(gender: "steps", args: [arg]);
  String homeTotalSteps(String arg) => "home".tr(gender: "total_steps", args: [arg]);

  // ranking
  String get rankingRanking => "rank".tr(gender: "ranking");
  String get rankingPoint => "rank".tr(gender: "point");
  String get rankingStepCount => "rank".tr(gender: "step_count");
  String get rankingRankingDescPoint => "rank".tr(gender: "ranking_desc_point");
  String get rankingRankingDescStepCount => "rank".tr(gender: "ranking_desc_step_count");

  // bottom navigation bar
  String get bnbQR => "bottom_navigation_bar".tr(gender: "qr");
  String get bnbHome => "bottom_navigation_bar".tr(gender: "home");

  // errors
  String get errorsConnectionError => "errors".tr(gender: "connection_error");
}