
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

  // 백그라운드에서 사용할 수 있는 직접 번역 메서드들
  String get lnOutOfRangeTitleFallback => "유효 걷기 범위를 벗어났습니다.";
  String get lnOutOfRangeBodyFallback => "걸음 수 기록이 일시정지됩니다.";
  String get lnBackInRangeTitleFallback => "유효 걷기 범위에 들어왔습니다.";
  String get lnBackInRangeBodyFallback => "걸음 수가 기록중입니다.";
  String get lnEventDurationFallback => "오늘의 행사 진행이 시작되었습니다.";
  String get lnEventDurationEndedFallback => "오늘의 행사 진행 시간이 종료되었습니다.";
  String get lnReachedTodaysMaxStepCountFallback => "오늘의 최대 걸음 수에 도달했습니다.";
  String get initialNotificationTitleFallback => "BEAT가 실행 중입니다.";
  String get initialNotificationContentFallback => "위치와 걸음 수를 기록 중입니다.";

  // 백그라운드에서 안전하게 번역을 가져오는 메서드
  String getSafeTranslation(String key, String fallback) {
    try {
      final result = key.tr();
      // 키값이 그대로 반환되는 경우 (번역이 실패한 경우) fallback 사용
      if (result == key || result.contains('local_notifications')) {
        return fallback;
      }
      return result;
    } catch (e) {
      return fallback;
    }
  }

  // genenral
  String get generalStudent => "general".tr(gender: "student");
  String get generalConfirm => "general".tr(gender: "confirm");
  String get generalCancel => "general".tr(gender: "cancel");
  String get generalDone => "general".tr(gender: "done");
  String get generalInitialNotificationTitle => getSafeTranslation("general.initial_notification_title", initialNotificationTitleFallback);
  String get generalInitialNotificationContent => getSafeTranslation("general.initial_notification_content", initialNotificationContentFallback);
  String get generalUpdateAvailable => "general".tr(gender: "update_available");
  String get generalUpdateAvailableContent => "general".tr(gender: "update_available_content");

  // android foreground notification
  String get afnTitle => "android_foreground_notification".tr(gender: "title");
  String get afnCountingStepsContent => "android_foreground_notification".tr(gender: "counting_steps_content");
  String get afnOutOfRangeContent => "android_foreground_notification".tr(gender: "out_of_range_content");
  String get afnNotEventDurationContent => "android_foreground_notification".tr(gender: "not_event_duration_content");

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
  String get homeQRQuest => "home".tr(gender: "qr_quest");
  String get homeWalkQuest => "home".tr(gender: "walk_quest");
  String get homeDaily => "home".tr(gender: "daily");
  String get homeWeekly => "home".tr(gender: "weekly");
  String get homeMonthly => "home".tr(gender: "monthly");
  String get homeNoQuests => "home".tr(gender: "no_quests");
  String get homeClaim => "home".tr(gender: "claim");
  String get homeClaimed => "home".tr(gender: "claimed");
  String get homeNoSurvey => "home".tr(gender: "no_survey");
  String get homeRewardAcquisitionComplete => "home".tr(gender: "reward_acquisition_complete");
  String get homeRewardAcquisitionCompleteContent => "home".tr(gender: "reward_acquisition_complete_content");
  String get homeRewardAcquisitionFailed => "home".tr(gender: "reward_acquisition_failed");
  String get homeBEATRequiresLocationPermissionTitle => "home".tr(gender: "beat_requires_location_permission_title");
  String get homeBEATRequiresLocationPermissionContent => "home".tr(gender: "beat_requires_location_permission_content");
  String get homeBEATRequiresActivityPermissionTitle => "home".tr(gender: "beat_requires_activity_permission_title");
  String get homeBEATRequiresActivityPermissionContent => "home".tr(gender: "beat_requires_activity_permission_content");
  String get homeBEATRequiresLocationAndActivityPermissionTitle => "home".tr(gender: "beat_requires_location_and_activity_permission_title");
  String get homePleaseChangeTheLocationAndActivityPermissions => "home".tr(gender: "please_change_the_location_and_activity_permissions_to_always_allow");
  String get homeBEATRequiresLocationAndActivityPermissionContent => "home".tr(gender: "beat_requires_location_and_activity_permission_content");
  String get homeNotInValidArea => "home".tr(gender: "not_in_valid_area");
  String get homeNotEventDuration => "home".tr(gender: "not_event_duration");
  String get homeReachedTodaysMaxStepCount => "home".tr(gender: "reached_todays_max_step_count");
  String get homePauseStepCount => "home".tr(gender: "pause_step_count");
  String get homeGotoSettings => "home".tr(gender: "go_to_settings");
  String get homeLater => "home".tr(gender: "later");

  // Quest Detail
  String get qdNoImage => "quest_detail".tr(gender: "no_image");
  String get qdDescription => "quest_detail".tr(gender: "quest_description");
  String get qdTotalReward => "quest_detail".tr(gender: "total_reward");
  String get qdQuestType => "quest_detail".tr(gender: "quest_type");
  String get qdQuestRequirement => "quest_detail".tr(gender: "quest_requirement");
  String get qdBonusReward => "quest_detail".tr(gender: "bonus_reward");
  String get qdProgress => "quest_detail".tr(gender: "progress");
  String get qdAdditionalInformation => "quest_detail".tr(gender: "additional_information");
  String get qdQuestTypeQR => "quest_detail".tr(gender: "quest_type_qr");
  String get qdQuestTypeWalk => "quest_detail".tr(gender: "quest_type_walk");
  String qdSteps(String arg) => "quest_detail".tr(gender: "steps", args: [arg]);
  String qdQRs(String arg) => "quest_detail".tr(gender: "qrs", args: [arg]);

  // Survey detail
  String get sdSurvey => "survey_detail".tr(gender: "survey");
  String sdQuestion(String arg) => "survey_detail".tr(gender: "question", args: [arg]);
  String get sdSubmit => "survey_detail".tr(gender: "submit");
  String get sdSubmitCompletedTitle => "survey_detail".tr(gender: "submit_completed_title");
  String get sdSubmitCompletedContent => "survey_detail".tr(gender: "submit_completed_content");
  String get sdSubmitErrorTitle => "survey_detail".tr(gender: "submit_error_title");
  String get sdSubmitErrorContent => "survey_detail".tr(gender: "submit_error_content");
  String get sdFetchSurveyFailedTitle => "survey_detail".tr(gender: "failed_to_fetch_survey_detail_title");
  String get sdFetchSurveyFailedContent => "survey_detail".tr(gender: "failed_to_fetch_survey_detail_content");

  // sign in
  String get signInSidOrId => "sign_in".tr(gender: "sid_or_id");
  String get signInSidOrIdHint => "sign_in".tr(gender: "sid_or_id_hint");
  String get signInPassword => "sign_in".tr(gender: "password");
  String get signInPasswordHint => "sign_in".tr(gender: "password_hint");
  String get signInSignIn => "sign_in".tr(gender: "sign_in");
  String get signInRegister => "sign_in".tr(gender: "register");
  String get signInForgotPassword => "sign_in".tr(gender: "forgot_password");
  String get signInSignInFailed => "sign_in".tr(gender: "sign_in_failed");

  // qr
  String get qrRewardAcquireFailed => "qr".tr(gender: "reward_acquire_failed");
  String get qrRewardAcquireSuccess => "qr".tr(gender: "reward_acquire_success");
  String get qrQRScanFailed => "qr".tr(gender: "qr_scan_failed");
  String get qrQRScanSuccess => "qr".tr(gender: "qr_scan_success");
  String qrQRScanSuccessDeductedPoint(String arg) => "qr".tr(gender: "qr_scan_success_deducted_point", args: [arg]);
  String qrQRScanSuccessEarnedPoint(String arg) => "qr".tr(gender: "qr_scan_success_earned_point", args: [arg]);
  String get qrAlreadyChecked => "qr".tr(gender: "already_checked");
  String get qrErrorOccured => "qr".tr(gender: "error_occured");
  String get qrLocationFetchErrorTitle => "qr".tr(gender: "location_fetch_error_title");
  String get qrLocationFetchErrorContent => "qr".tr(gender: "location_fetch_error_content");
  String get qrScanTitle => "qr".tr(gender: "qr_scan_title");
  String get qrScanContent => "qr".tr(gender: "qr_scan_content");
  String get qrInvalidQRTitle => "qr".tr(gender: "invalid_qr_code_title");
  String get qrInvalidQRContent => "qr".tr(gender: "invalid_qr_code_content");
  String get qrSurveyQRTitle => "qr".tr(gender: "survey_qr_title");
  String get qrSurveyQRContent => "qr".tr(gender: "survey_qr_content");
  String get qrBEATRequiresCameraPermissionTitle => "qr".tr(gender: "beat_requires_camera_permission_title");
  String get qrBEATRequiresCameraPermissionContent => "qr".tr(gender: "beat_requires_camera_permission_content");
  String get qrGotoSettings => "qr".tr(gender: "go_to_settings");
  String get qrLater => "qr".tr(gender: "later");
  String get qrConfirm => "qr".tr(gender: "confirm");
  String get qrCancel => "qr".tr(gender: "cancel");

  // notice
  String get noticeLabel => "notice".tr(gender: "label");
  String get noticeNoNotices => "notice".tr(gender: "no_notices");

  // ranking
  String get rankingRanking => "rank".tr(gender: "ranking");
  String get rankingPoint => "rank".tr(gender: "point");
  String get rankingStepCount => "rank".tr(gender: "step_count");
  String get rankingRankingDescPoint => "rank".tr(gender: "ranking_desc_point");
  String get rankingRankingDescStepCount => "rank".tr(gender: "ranking_desc_step_count");
  String get rankingPointRankerList => "rank".tr(gender: "point_ranker_list");
  String get rankingPointRankerListStudent => "rank".tr(gender: "point_ranker_list_student");
  String get rankingPointRankerListEmployee => "rank".tr(gender: "point_ranker_list_employee");
  String get rankingWalkRankerList => "rank".tr(gender: "walk_ranker_list");
  String get rankingWalkRankerListStudent => "rank".tr(gender: "walk_ranker_list_student");
  String get rankingWalkRankerListEmployee => "rank".tr(gender: "walk_ranker_list_employee");
  String get rankingMyRank => "rank".tr(gender: "my_rank");

  // register organization
  String get roAppbarTitle => "register_organization".tr(gender: "appbar_title");
  String get roStudent => "register_organization".tr(gender: "student");
  String get roFacultyAndStaff => "register_organization".tr(gender: "faculty_and_staff");
  String roContinueWith(String arg) => "register_organization".tr(gender: "continue_with", args: [arg]);

  // register collage
  String get rcAppbarTitle => "register_college".tr(gender: "appbar_title");
  String rcContinueWith(String arg) => "register_college".tr(gender: "continue_with", args: [arg]);

  // register department
  String get rdAppbarTitle => "register_department".tr(gender: "appbar_title");
  String rdContinueWith(String arg) => "register_department".tr(gender: "continue_with", args: [arg]);

  // register affiliation
  String get raAppbarTitle => "register_affiliation".tr(gender: "appbar_title");
  String get raAffiliationHint => "register_affiliation".tr(gender: "affiliation_hint");
  String get raInappropriateAffiliationTitle => "register_affiliation".tr(gender: "inappropriate_affiliation_title");
  String get raInappropriateAffiliationContent => "register_affiliation".tr(gender: "inappropriate_affiliation_content");
  String raContinueWith(String arg) => "register_affiliation".tr(gender: "continue_with", args: [arg]);

  // register fill inform
  String get rfiAppbarTitle => "register_fill_inform_page".tr(gender: "appbar_title");
  String get rfiName => "register_fill_inform_page".tr(gender: "name");
  String get rfiInavailableNameMessage => "register_fill_inform_page".tr(gender: "inavailable_name_message");
  String get rfiInavailableNameMessage2 => "register_fill_inform_page".tr(gender: "inavailable_name_message2");
  String get rfiNameHasInitialConsonant => "register_fill_inform_page".tr(gender: "name_has_initial_consonant");
  String get rfiNameIsEmpty => "register_fill_inform_page".tr(gender: "name_is_empty");
  String get rfiNameHint => "register_fill_inform_page".tr(gender: "name_hint");
  String get rfiStudentId => "register_fill_inform_page".tr(gender: "student_id");
  String get rfiStudentIdHint => "register_fill_inform_page".tr(gender: "student_id_hint");
  String get rfiEmployeeMail => "register_fill_inform_page".tr(gender: "employee_mail");
  String get rfiEmployeeMailHint => "register_fill_inform_page".tr(gender: "employee_mail_hint");
  String get rfiSidTooShort => "register_fill_inform_page".tr(gender: "sid_too_short");
  String get rfiMailIsEmpty => "register_fill_inform_page".tr(gender: "mail_is_empty");
  String get rfiValidateMail => "register_fill_inform_page".tr(gender: "validate_mail");
  String get rfiMailSent => "register_fill_inform_page".tr(gender: "mail_sent");
  String get rfiInvalidMailContent => "register_fill_inform_page".tr(gender: "invalid_mail_content");
  String get rfiCheckMailVerify => "register_fill_inform_page".tr(gender: "check_mail_verify");
  String get rfiEmailVerified => "register_fill_inform_page".tr(gender: "email_verified");
  String get rfiEmailCheckSuccessTitle => "register_fill_inform_page".tr(gender: "email_check_success_title");
  String get rfiEmailCheckSuccessContent => "register_fill_inform_page".tr(gender: "email_check_success_content");
  String get rfiEmailNotCheckTitle => "register_fill_inform_page".tr(gender: "email_not_check_title");
  String get rfiEmailNotCheckContent => "register_fill_inform_page".tr(gender: "email_not_check_content");
  String get rfiEmailCheckFailedTitle => "register_fill_inform_page".tr(gender: "email_check_failed_title");
  String get rfiEmailCheckFailedContent => "register_fill_inform_page".tr(gender: "email_check_failed_content");
  String get rfiEmailSentTitle => "register_fill_inform_page".tr(gender: "email_sent_title");
  String rfiEmailSentMessage(String arg) => "register_fill_inform_page".tr(gender: "email_sent_message", args: [arg]);
  String get rfiEmailSentErrorTitle => "register_fill_inform_page".tr(gender: "email_sent_error_title");
  String get rfiNickname => "register_fill_inform_page".tr(gender: "nickname");
  String get rfiValidateNickname => "register_fill_inform_page".tr(gender: "validate_nickname");
  String get rfiNicknameChecked => "register_fill_inform_page".tr(gender: "nickname_checked");
  String get rfiNicknameCheckedTitle => "register_fill_inform_page".tr(gender: "nickname_checked_title");
  String get rfiNicknameCheckedMessage => "register_fill_inform_page".tr(gender: "nickname_checked_message");
  String get rfiNicknameUncheckedTitle => "register_fill_inform_page".tr(gender: "nickname_unchecked_title");
  String get rfiNicknameUncheckedMessage => "register_fill_inform_page".tr(gender: "nickname_unchecked_message");
  String get rfiNicknameCheckErrorTitle => "register_fill_inform_page".tr(gender: "nickname_check_error_title");
  String get rfiNicknameCheckErrorMessage => "register_fill_inform_page".tr(gender: "nickname_check_error_message");
  String get rfiNicknameHasInitialConsonant => "register_fill_inform_page".tr(gender: "nickname_has_initial_consonant");
  String get rfiInappropriateNicknameMessage => "register_fill_inform_page".tr(gender: "inapropriate_nickname_message");
  String get rfiNicknameIsEmpty => "register_fill_inform_page".tr(gender: "nickname_is_empty");
  String get rfiNicknameTooShort => "register_fill_inform_page".tr(gender: "nickname_too_short");
  String get rfiNicknameHint => "register_fill_inform_page".tr(gender: "nickname_hint");
  String get rfiPassword => "register_fill_inform_page".tr(gender: "password");
  String get rfiPasswordHint => "register_fill_inform_page".tr(gender: "password_hint");
  String get rfiPasswordIsEmpty => "register_fill_inform_page".tr(gender: "password_is_empty");
  String get rfiPasswordCheckIsEmpty => "register_fill_inform_page".tr(gender: "password_check_is_empty");
  String get rfiPasswordCheck => "register_fill_inform_page".tr(gender: "password_check");
  String get rfiPasswordCheckHint => "register_fill_inform_page".tr(gender: "password_check_hint");
  String get rfiPasswordRuleErrorContent => "register_fill_inform_page".tr(gender: "password_rule_error_content");
  String get rfiPasswordMismatchContent => "register_fill_inform_page".tr(gender: "password_mismatch_content");
  String get rfiWhyDoINeedToSign => "register_fill_inform_page".tr(gender: "why_do_i_need_to_sign");
  String get rfiWdintsContent => "register_fill_inform_page".tr(gender: "wdints_content");
  String get rfiSign => "register_fill_inform_page".tr(gender: "sign");
  String get rfiSignIsEmptyTitle => "register_fill_inform_page".tr(gender: "sign_is_empty_error_title");
  String get rfiSignIsEmptyContent => "register_fill_inform_page".tr(gender: "sign_is_empty_error_content");
  String get rfiTermsOfAgreement => "register_fill_inform_page".tr(gender: "terms_of_agreement");
  String get rfiToaPurpose => "register_fill_inform_page".tr(gender: "toa_purpose");
  String get rfiToaPurposeContent => "register_fill_inform_page".tr(gender: "toa_purpose_content");
  String get rfiToaItems => "register_fill_inform_page".tr(gender: "toa_items");
  String get rfiToaItemsContent => "register_fill_inform_page".tr(gender: "toa_items_content");
  String get rfiToaRetention => "register_fill_inform_page".tr(gender: "toa_retention");
  String get rfiToaRetentionContent => "register_fill_inform_page".tr(gender: "toa_retention_content");
  String get rfiToaRightToRefusal => "register_fill_inform_page".tr(gender: "toa_right_to_refusal");
  String get rfiToaRightToRefusalContent => "register_fill_inform_page".tr(gender: "toa_right_to_refusal_content");
  String get rfiDoYouAgree => "register_fill_inform_page".tr(gender: "do_you_agree");
  String get rfiIAgree => "register_fill_inform_page".tr(gender: "i_agree");
  String get rfiSignUp => "register_fill_inform_page".tr(gender: "sign_up");
  String get rfiSignUpSuccess => "register_fill_inform_page".tr(gender: "sign_up_success");
  String get rfiSignUpSuccessMessage => "register_fill_inform_page".tr(gender: "sign_up_success_message");
  String get rfiToSignInScreen => "register_fill_inform_page".tr(gender: "to_sign_in_screen");
  String get rfiSignUpFailed => "register_fill_inform_page".tr(gender: "sign_up_failed");
  String get rfiSignUpFailedMessage => "register_fill_inform_page".tr(gender: "sign_up_failed_message");

  // Sign Page
  String get signSignFailed => "sign_page".tr(gender: "sign_failed");
  String get signFailedToConvertSignatureContent => "sign_page".tr(gender: "failed_to_convert_signature_content");

  // Sign Preview
  String get spSignContent => "sign_preview".tr(gender: "sign_content");

  // reset password
  String get rpAppbarTitle => "reset_password".tr(gender: "appbar_title");
  String get rpSidOrEmployeeId => "reset_password".tr(gender: "sid_or_employee_id");
  String get rpSidOrEmployeeIdHint => "reset_password".tr(gender: "sid_or_employee_id_hint");
  String get rpSidOrEmployeeIdIsEmpty => "reset_password".tr(gender: "sid_or_employee_id_is_empty");
  String get rpInvalidSidOrEmployeeId => "reset_password".tr(gender: "invalid_sid_or_employee_id");
  String get rpValidateMail => "reset_password".tr(gender: "validate_mail");
  String get rpMailSent => "reset_password".tr(gender: "mail_sent");
  String get rpEmailSentTitle => "reset_password".tr(gender: "email_sent_title");
  String rpEmailSentMessage(String arg) => "reset_password".tr(gender: "email_sent_message", args: [arg]);
  String get rpValidateMailSuccessTitle => "reset_password".tr(gender: "validate_mail_success_title");
  String get rpValidateMailSuccessContent => "reset_password".tr(gender: "validate_mail_success_content");
  String get rpValidateMailErrorTitle => "reset_password".tr(gender: "validate_mail_error_title");
  String get rpValidateMailErrorContent => "reset_password".tr(gender: "validate_mail_error_content");
  String get rpValidationCode => "reset_password".tr(gender: "validation_code");
  String get rpValidationCodeHint => "reset_password".tr(gender: "validation_code_hint");
  String get rpValidationCodeIsEmpty => "reset_password".tr(gender: "validation_code_is_empty");
  String get rpValidationCodeIsTooShort => "reset_password".tr(gender: "validation_code_is_too_short");
  String get rpVerifyCode => "reset_password".tr(gender: "verify_code");
  String get rpCodeVerified => "reset_password".tr(gender: "code_verified");
  String get rpVerifyCodeSuccessTitle => "reset_password".tr(gender: "verify_code_success_title");
  String get rpVerifyCodeSuccessContent => "reset_password".tr(gender: "verify_code_success_content");
  String get rpVerifyCodeNotCorrectTitle => "reset_password".tr(gender: "verify_code_not_correct_title");
  String get rpVerifyCodeNotCorrectContent => "reset_password".tr(gender: "verify_code_not_correct_content");
  String get rpVerifyCodeFailedTitle => "reset_password".tr(gender: "verify_code_failed_title");
  String get rpVerifyCodeFailedContent => "reset_password".tr(gender: "verify_code_failed_content");
  String get rpNewPassword => "reset_password".tr(gender: "new_password");
  String get rpNewPasswordHint => "reset_password".tr(gender: "new_password_hint");
  String get rpNewPasswordIsEmpty => "reset_password".tr(gender: "new_password_is_empty");
  String get rpNewPasswordCheck => "reset_password".tr(gender: "new_password_check");
  String get rpNewPasswordCheckHint => "reset_password".tr(gender: "new_password_check_hint");
  String get rpNewPasswordCheckIsEmpty => "reset_password".tr(gender: "new_password_check_is_empty");
  String get rpPasswordRuleErrorTitle => "reset_password".tr(gender: "password_rule_error_title");
  String get rpPasswordRuleErrorContent => "reset_password".tr(gender: "password_rule_error_content");
  String get rpPasswordMismatchTitle => "reset_password".tr(gender: "password_mismatch_title");
  String get rpPasswordMismatchContent => "reset_password".tr(gender: "password_mismatch_content");
  String get rpResetPassword => "reset_password".tr(gender: "reset_password");
  String get rpResetPasswordSuccessTitle => "reset_password".tr(gender: "reset_password_success_title");
  String get rpResetPasswordSuccessContent => "reset_password".tr(gender: "reset_password_success_content");
  String get rpResetPasswordUnknownErrorTitle => "reset_password".tr(gender: "reset_password_unknown_error_title");
  String get rpResetPasswordUnknownErrorContent => "reset_password".tr(gender: "reset_password_unknown_error_content");
  String get rpConfirm => "reset_password".tr(gender: "confirm");

  // my page
  String get mpAppbarTitle => "my_page".tr(gender: "appbar_title");
  String get mpCategory => "my_page".tr(gender: "category");
  String get mpStudent => "my_page".tr(gender: "student");
  String get mpEmployee => "my_page".tr(gender: "employee");
  String get mpOthers => "my_page".tr(gender: "others");
  String get mpStudentID => "my_page".tr(gender: "student_id");
  String get mpEmployeeID => "my_page".tr(gender: "employee_id");
  String get mpID => "my_page".tr(gender: "id");
  String get mpName => "my_page".tr(gender: "name");
  String get mpDepartment => "my_page".tr(gender: "department");
  String get mpAffiliation => "my_page".tr(gender: "affiliation");
  String get mpEmail => "my_page".tr(gender: "email");
  String get mpNickname => "my_page".tr(gender: "nickname");
  String get mpChangePassword => "my_page".tr(gender: "change_password");
  String get mpTodayWalkCount => "my_page".tr(gender: "today_walk_count");
  String get mpLastWeekMean => "my_page".tr(gender: "last_week_walk_mean");
  String get mpLastMonthMean => "my_page".tr(gender: "last_month_walk_mean");
  String get mpMyTotalRanking => "my_page".tr(gender: "my_total_ranking");
  String get mpTotalWalkCount => "my_page".tr(gender: "total_walk_count");
  String get mpTotalPoint => "my_page".tr(gender: "total_point");
  String mpNthPlace(String arg) => "my_page".tr(gender: "nth_place", args: [arg]);
  String mpCategoryRanking(String arg) => "my_page".tr(gender: "my_category_ranking", args: [arg]);

  // History
  String get historyHistory => "history".tr(gender: "history");
  String get historyHistoryDesc => "history".tr(gender: "history_desc");

  // bottom navigation bar
  String get bnbQR => "bottom_navigation_bar".tr(gender: "qr");
  String get bnbHome => "bottom_navigation_bar".tr(gender: "home");
  String get bnbMyPage => "bottom_navigation_bar".tr(gender: "my_page");

  // local notifications
  String get lnOutOfRangeTitle => getSafeTranslation("local_notifications.out_of_range_title", lnOutOfRangeTitleFallback);
  String get lnOutOfRangeBody => getSafeTranslation("local_notifications.out_of_range_body", lnOutOfRangeBodyFallback);
  String get lnBackInRangeTitle => getSafeTranslation("local_notifications.back_in_range_title", lnBackInRangeTitleFallback);
  String get lnBackInRangeBody => getSafeTranslation("local_notifications.back_in_range_body", lnBackInRangeBodyFallback);
  String get lnEventDuration => getSafeTranslation("local_notifications.event_duration_title", lnEventDurationFallback);
  String get lnEventDurationEnded => getSafeTranslation("local_notifications.event_duration_ended_title", lnEventDurationEndedFallback);
  String get lnReachedTodaysMaxStepCount => getSafeTranslation("local_notifications.reached_todays_max_step_count_title", lnReachedTodaysMaxStepCountFallback);

  // settings
  String get settingsAppbarTitle => "settings".tr(gender: "appbar_title");
  String get settingsSignOut => "settings".tr(gender: "sign_out");
  String get settingsWithdrawal => "settings".tr(gender: "withdrawal");
  String get settingsOSSLicenses => "settings".tr(gender: "oss_licenses");
  String get settingsViewDetail => "settings".tr(gender: "view_detail");
  String get settingsAppInquiry => "settings".tr(gender: "app_inquiry");
  String get settingsEmail => "settings".tr(gender: "email");
  String get settingsEmailAddress => "settings".tr(gender: "email_address");
  String get settingsPhone => "settings".tr(gender: "phone");
  String get settingsPhoneNumber => "settings".tr(gender: "phone_number");
  String get settingsVersion => "settings".tr(gender: "version");

  // withdrawal
  String get withdrawalAppbarTitle => "withdrawal".tr(gender: "appbar_title");
  String get withdrawalNotes => "withdrawal".tr(gender: "notes");
  String get withdrawalNote1 => "withdrawal".tr(gender: "note_1");
  String get withdrawalNote2 => "withdrawal".tr(gender: "note_2");
  String get withdrawalNote3 => "withdrawal".tr(gender: "note_3");
  String get withdrawalNote4 => "withdrawal".tr(gender: "note_4");
  String get withdrawalDoYouAgree => "withdrawal".tr(gender: "do_you_agree");
  String get withdrawalIAgree => "withdrawal".tr(gender: "i_agree");
  String get withdrawal => "withdrawal".tr(gender: "withdrawal");
  String get withdrawalSuccess => "withdrawal".tr(gender: "withdrawal_success");
  String get withdrawalSuccessMessage => "withdrawal".tr(gender: "withdrawal_success_message");
  String get withdrawalFailed => "withdrawal".tr(gender: "withdrawal_failed");
  String get withdrawalFailedMessage => "withdrawal".tr(gender: "withdrawal_failed_message");
  String get withdrawalConfirm => "withdrawal".tr(gender: "confirm");
  String get withdrawalCancel => "withdrawal".tr(gender: "cancel");

  // errors
  String get errorsTimeout => "errors".tr(gender: "timeout");
  String get errorsConnectionError => "errors".tr(gender: "connection_error");
  String get errorsUnknown => "errors".tr(gender: "unknown");
  String get errorsUnknownDetail => "errors".tr(gender: "unknown_detail");

  // others
  List<String> get colleges => "colleges".tr().split(", ");
  List<String> get departments => "departments".tr().split(", ");
  List<String> departmentsFromCollage(String collage) => "departments".tr(gender: collage).split(", ");
  List<String> get departmentsOld => "departments_old".tr().split(", ");
  List<String> departmentsOldFromCollege(String college) => "departments_old".tr(gender: college).split(", ");
}