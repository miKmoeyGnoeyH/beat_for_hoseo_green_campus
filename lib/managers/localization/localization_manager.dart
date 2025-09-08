
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
  // genenral
  String get generalStudent => "general".tr(gender: "student");

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
  String get homeRewardAcquisitionComplete => "home".tr(gender: "reward_acquisition_complete");
  String get homeRewardAcquisitionFailed => "home".tr(gender: "reward_acquisition_failed");

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

  // notice
  String get noticeLabel => "notice".tr(gender: "label");

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

  // register fill inform
  String get rfiAppbarTitle => "register_fill_inform_page".tr(gender: "appbar_title");
  String get rfiName => "register_fill_inform_page".tr(gender: "name");
  String get rfiNameHint => "register_fill_inform_page".tr(gender: "name_hint");
  String get rfiStudentId => "register_fill_inform_page".tr(gender: "student_id");
  String get rfiStudentIdHint => "register_fill_inform_page".tr(gender: "student_id_hint");
  String get rfiSidOrEmployeeId => "register_fill_inform_page".tr(gender: "sid_or_employee_id");
  String get rfiSidOrEmployeeIdHint => "register_fill_inform_page".tr(gender: "sid_or_employee_id_hint");
  String get rfiId => "register_fill_inform_page".tr(gender: "id");
  String get rfiIdHint => "register_fill_inform_page".tr(gender: "id_hint");
  String get rfiValidateMail => "register_fill_inform_page".tr(gender: "validate_mail");
  String get rfiValidateId => "register_fill_inform_page".tr(gender: "validate_id");
  String get rfiEmailSentTitle => "register_fill_inform_page".tr(gender: "email_sent_title");
  String get rfiEmailSentMessage => "register_fill_inform_page".tr(gender: "email_sent_message");
  String get rfiEmailSentErrorTitle => "register_fill_inform_page".tr(gender: "email_sent_error_title");
  String get rfiEmailSentErrorMessage => "register_fill_inform_page".tr(gender: "email_sent_error_message");
  String get rfiIdCheckTitle => "register_fill_inform_page".tr(gender: "id_check_title");
  String get rfiIdCheckMessage => "register_fill_inform_page".tr(gender: "id_check_message");
  String get rfiIdCheckErrorTitle => "register_fill_inform_page".tr(gender: "id_check_error_title");
  String get rfiIdCheckErrorMessage => "register_fill_inform_page".tr(gender: "id_check_error_message");
  String get rfiNickname => "register_fill_inform_page".tr(gender: "nickname");
  String get rfiValidateNickname => "register_fill_inform_page".tr(gender: "validate_nickname");
  String get rfiNicknameChecked => "register_fill_inform_page".tr(gender: "nickname_checked");
  String get rfiNicknameCheckedTitle => "register_fill_inform_page".tr(gender: "nickname_checked_title");
  String get rfiNicknameCheckedMessage => "register_fill_inform_page".tr(gender: "nickname_checked_message");
  String get rfiNicknameUncheckedTitle => "register_fill_inform_page".tr(gender: "nickname_unchecked_title");
  String get rfiNicknameUncheckedMessage => "register_fill_inform_page".tr(gender: "nickname_unchecked_message");
  String get rfiNicknameCheckErrorTitle => "register_fill_inform_page".tr(gender: "nickname_check_error_title");
  String get rfiNicknameCheckErrorMessage => "register_fill_inform_page".tr(gender: "nickname_check_error_message");
  String get rfiInappropriateNickname => "register_fill_inform_page".tr(gender: "inapropriate_nickname");
  String get rfiNicknameHasInitialConsonant => "register_fill_inform_page".tr(gender: "nickname_has_initial_consonant");
  String get rfiInappropriateNicknameMessage => "register_fill_inform_page".tr(gender: "inapropriate_nickname_message");
  String get rfiNicknameHint => "register_fill_inform_page".tr(gender: "nickname_hint");
  String get rfiPassword => "register_fill_inform_page".tr(gender: "password");
  String get rfiPasswordHint => "register_fill_inform_page".tr(gender: "password_hint");
  String get rfiPasswordCheck => "register_fill_inform_page".tr(gender: "password_check");
  String get rfiPasswordCheckHint => "register_fill_inform_page".tr(gender: "password_check_hint");
  String get rfiPasswordRuleErrorTitle => "register_fill_inform_page".tr(gender: "password_rule_error_title");
  String get rfiPasswordRuleErrorContent => "register_fill_inform_page".tr(gender: "password_rule_error_content");
  String get rfiPasswordMismatchTitle => "register_fill_inform_page".tr(gender: "password_mismatch_title");
  String get rfiPasswordMismatchContent => "register_fill_inform_page".tr(gender: "password_mismatch_content");
  String get rfiWhyDoINeedToSign => "register_fill_inform_page".tr(gender: "why_do_i_need_to_sign");
  String get rfiWdintsContent => "register_fill_inform_page".tr(gender: "wdints_content");
  String get rfiSign => "register_fill_inform_page".tr(gender: "sign");
  String get rfiSignContent => "register_fill_inform_page".tr(gender: "sign_content");
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

  // Terms of Agreement
  String get toa => "terms_of_agreement".tr();
  String get toaPurpose => "terms_of_agreement_content".tr(gender: "purpose");
  String get toaPurposeContent => "terms_of_agreement_content".tr(gender: "purpose_content");
  String get toaItems => "terms_of_agreement_content".tr(gender: "items");
  String get toaItemsContentStudent => "terms_of_agreement_content".tr(gender: "items_content_student");
  String get toaRetention => "terms_of_agreement_content".tr(gender: "retention");
  String get toaRetentionContent => "terms_of_agreement_content".tr(gender: "retention_content");
  String get toaRightToRefusal => "terms_of_agreement_content".tr(gender: "right_to_refusal");
  String get toaRightToRefusalContent => "terms_of_agreement_content".tr(gender: "right_to_refusal_content");

  // reset password
  String get rpAppbarTitle => "reset_password".tr(gender: "appbar_title");
  String get rpSidOrEmployeeId => "reset_password".tr(gender: "sid_or_employee_id");
  String get rpSidOrEmployeeIdHint => "reset_password".tr(gender: "sid_or_employee_id_hint");
  String get rpValidateMailSuccessTitle => "reset_password".tr(gender: "validate_mail_success_title");
  String get rpValidateMailSuccessContent => "reset_password".tr(gender: "validate_mail_success_content");
  String get rpValidateMail => "reset_password".tr(gender: "validate_mail");
  String get rpValidateMailErrorTitle => "reset_password".tr(gender: "validate_mail_error_title");
  String get rpValidateMailErrorContent => "reset_password".tr(gender: "validate_mail_error_content");
  String get rpValidationCode => "reset_password".tr(gender: "validation_code");
  String get rpValidationCodeHint => "reset_password".tr(gender: "validation_code_hint");
  String get rpNewPassword => "reset_password".tr(gender: "new_password");
  String get rpNewPasswordHint => "reset_password".tr(gender: "new_password_hint");
  String get rpNewPasswordCheck => "reset_password".tr(gender: "new_password_check");
  String get rpNewPasswordCheckHint => "reset_password".tr(gender: "new_password_check_hint");
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
  String get mpEmail => "my_page".tr(gender: "email");
  String get mpNickname => "my_page".tr(gender: "nickname");
  String get mpChangePassword => "my_page".tr(gender: "change_password");

  // bottom navigation bar
  String get bnbQR => "bottom_navigation_bar".tr(gender: "qr");
  String get bnbHome => "bottom_navigation_bar".tr(gender: "home");
  String get bnbMyPage => "bottom_navigation_bar".tr(gender: "my_page");

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