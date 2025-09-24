import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:beat_flutter/components/global/methods/custom_show_dialog.dart';
import 'package:beat_flutter/components/global/widgets/appbars/custom_appbar.dart';
import 'package:beat_flutter/components/global/widgets/buttons/custom_bottom_appbar_button.dart';
import 'package:beat_flutter/components/global/widgets/buttons/custom_text_button.dart';
import 'package:beat_flutter/components/global/widgets/buttons/custom_wide_button.dart';
import 'package:beat_flutter/components/global/widgets/custom_circular_progress_indicator.dart';
import 'package:beat_flutter/components/global/widgets/custom_scaffold.dart';
import 'package:beat_flutter/components/global/widgets/custom_text_field.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_subtitle_large.dart';
import 'package:beat_flutter/components/register_fill_inform/widgets/rfi_regexp.dart';
import 'package:beat_flutter/controller/location/location_controller.dart';
import 'package:beat_flutter/controller/pedometer/pedometer_controller.dart';
import 'package:beat_flutter/controller/user_controller.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/dotenv/dotenv_manager.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:beat_flutter/managers/prefs/prefs_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final LocalizationManager localizationManager = LocalizationManager();

  final TextEditingController idController = TextEditingController();

  final TextEditingController validationCodeController =
      TextEditingController();

  final TextEditingController newPasswordController = TextEditingController();

  final TextEditingController passwordCheckController = TextEditingController();

  final FocusNode idFocusNode = FocusNode();
  final FocusNode validationFocusNode = FocusNode();
  final FocusNode newPasswordFocusNode = FocusNode();
  final FocusNode passwordCheckFocusNode = FocusNode();

  final int maxIdLength = 8;
  final int maxValidationCodeLength = 6;
  final int minPasswordLength = 8;

  bool isValidateMailButtonEnabled = false;
  bool isValidateMailSent = false;

  bool isValidationCodeButtonEnabled = false;
  bool isValidationCodeCorrect = false;

  bool isPasswordValid = false;

  bool get _isSignUpButtonEnabled => isValidationCodeCorrect && isPasswordValid;

  @override
  void initState() {
    idController.addListener(() {
      setState(() {});
    });
    validationCodeController.addListener(() {
      setState(() {});
    });
    newPasswordController.addListener(() {
      setState(() {});
    });
    passwordCheckController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    idController.dispose();
    validationCodeController.dispose();
    newPasswordController.dispose();
    passwordCheckController.dispose();

    // 👇 FocusNode 정리
    idFocusNode.dispose();
    validationFocusNode.dispose();
    newPasswordFocusNode.dispose();
    passwordCheckFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: CustomScaffold(
        // hasScrollBody: false,
        appBar: CustomAppBar(
          title: Text(localizationManager.rpAppbarTitle),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.w),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      textEditingController: idController,
                      focusNode: idFocusNode,
                      labelText: localizationManager.rpSidOrEmployeeId,
                      hintText: localizationManager.rpSidOrEmployeeIdHint,
                      maxLines: idFocusNode.hasFocus ? 2 : 1,
                      onChanged: (value) {
                        setState(() {
                          // 입력 즉시 버튼 상태 업데이트
                          if (value.isEmpty) {
                            isValidateMailButtonEnabled = false;
                          } else if (!emailRegExp.hasMatch(value)) {
                            isValidateMailButtonEnabled = false;
                          } else {
                            isValidateMailButtonEnabled = true;
                          }
                          isValidateMailSent = false;
                          isValidationCodeCorrect = false;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localizationManager.rpSidOrEmployeeIdIsEmpty;
                        } else if (!emailRegExp.hasMatch(value)) {
                          return localizationManager.rpInvalidSidOrEmployeeId;
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    SizedBox(height: 16.w),
                    CustomWideButton(
                      // width: 120.w,
                      height: 50.w,
                      autoSizeText: true,
                      borderRadius: 10,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.w,
                      ),
                      onTap: (isValidateMailButtonEnabled)
                          ? () async {
                              FocusScope.of(context).unfocus();
                              isValidateMailButtonEnabled = false;
                              onValidateMailButtonTap();
                            }
                          : () {},
                      buttonText: isValidateMailSent
                          ? localizationManager.rpMailSent
                          : localizationManager.rpValidateMail,
                      buttonColor: isValidateMailSent
                          ? context.appColors.disabled
                          : isValidateMailButtonEnabled
                              ? context.appColors.primary
                              : context.appColors.disabled,
                    ),
                  ],
                ),
                SizedBox(height: 35.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      textEditingController: validationCodeController,
                      focusNode: validationFocusNode,
                      labelText: localizationManager.rpValidationCode,
                      hintText: localizationManager.rpValidationCodeHint,
                      maxLength: maxValidationCodeLength,
                      maxLines: validationFocusNode.hasFocus ? 2 : 1,
                      onChanged: (value) {
                        setState(
                          () {
                            if (value.isEmpty) {
                              isValidationCodeButtonEnabled = false;
                            } else if (value.length < maxValidationCodeLength) {
                              isValidationCodeButtonEnabled = false;
                            } else {
                              isValidationCodeButtonEnabled = true;
                            }
                            isValidationCodeCorrect = false;
                          },
                        );
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localizationManager.rpValidationCodeIsEmpty;
                        } else if (value.length < maxValidationCodeLength) {
                          return localizationManager.rpValidationCodeIsTooShort;
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    SizedBox(height: 16.w),
                    CustomWideButton(
                      // width: 120.w,
                      height: 50.w,
                      autoSizeText: true,
                      borderRadius: 10,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.w,
                      ),
                      onTap: (isValidationCodeButtonEnabled)
                          ? () async {
                              FocusScope.of(context).unfocus();
                              isValidateMailButtonEnabled = false;
                              onVerifyCodeButtonTap();
                            }
                          : () {},
                      buttonText: isValidationCodeCorrect
                          ? localizationManager.rpCodeVerified
                          : localizationManager.rpVerifyCode,
                      buttonColor: isValidationCodeCorrect
                          ? context.appColors.disabled
                          : isValidationCodeButtonEnabled
                              ? context.appColors.primary
                              : context.appColors.disabled,
                    ),
                  ],
                ),
                SizedBox(height: 35.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      textEditingController: newPasswordController,
                      focusNode: newPasswordFocusNode,
                      labelText: localizationManager.rpNewPassword,
                      hintText: localizationManager.rpNewPasswordHint,
                      // maxLength: maxValidationCodeLength,
                      maxLines: newPasswordFocusNode.hasFocus ? 2 : 1,
                      obscureText:
                          newPasswordController.text.isEmpty ? false : true,
                      onChanged: (value) {
                        setState(() {});
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localizationManager.rpNewPasswordIsEmpty;
                        } else if (!passwordRegex.hasMatch(value)) {
                          return localizationManager.rpPasswordRuleErrorContent;
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                  ],
                ),
                SizedBox(height: 35.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      textEditingController: passwordCheckController,
                      focusNode: passwordCheckFocusNode,
                      labelText: localizationManager.rpNewPasswordCheck,
                      hintText: localizationManager.rpNewPasswordCheckHint,
                      // maxLength: maxValidationCodeLength,
                      maxLines: passwordCheckFocusNode.hasFocus ? 2 : 1,
                      obscureText:
                          passwordCheckController.text.isEmpty ? false : true,
                      onChanged: (value) {
                        setState(
                          () {
                            if (value.isEmpty) {
                              isPasswordValid = false;
                            } else if (value != newPasswordController.text) {
                              isPasswordValid = false;
                            } else {
                              isPasswordValid = true;
                            }
                          },
                        );
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localizationManager.rpNewPasswordIsEmpty;
                        } else if (value != newPasswordController.text) {
                          return localizationManager.rpPasswordMismatchContent;
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                  ],
                ),
                SizedBox(height: 50.w)
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomAppbarButton(
          onTap: _isSignUpButtonEnabled
              ? () {
                  FocusScope.of(context).unfocus();
                  onBottomAppbarButtonTap();
                }
              : () {
            log("isValidationCodeCorrect: $isValidationCodeCorrect, isPasswordValid: $isPasswordValid");
          },
          backgroundColor: _isSignUpButtonEnabled
              ? context.appColors.primary
              : context.appColors.disabled,
          text: localizationManager.rpResetPassword,
          textColor: _isSignUpButtonEnabled
              ? context.appColors.onPrimary
              : context.appColors.onBackground,
        ),
      ),
    );
  }

  void onValidateMailButtonTap() async {
    final String requestUrl = DotEnvManager().resetPasswordEmailRequest;

    try {
      final http.Response response = await Get.showOverlay(
        asyncFunction: () => http
            .get(
              Uri.parse("$requestUrl?studentId=${idController.text}"),
            )
            .timeout(const Duration(seconds: 10)),
        loadingWidget: const CustomCircularProgressIndicator(),
      );

      log("ResetPassword: onValidateMailButtonTap: response.body: ${response.body}");

      if (response.statusCode == 200) {
        customShowDialog(
          context: context,
          title: localizationManager.rpEmailSentTitle,
          content: localizationManager.rpEmailSentMessage(response.body),
        );
        isValidateMailSent = true;
      } else {
        customShowDialog(
          context: context,
          title: localizationManager.rpValidateMailErrorTitle,
          content: response.body,
        );
        isValidateMailSent = false;
      }
    } on TimeoutException {
      log("ResetPassword: onValidateMailButtonTap: TimeoutException");

      customShowDialog(
        context: context,
        title: localizationManager.errorsTimeout,
        content: localizationManager.errorsConnectionError,
      );

      isValidateMailSent = false;
    } catch (e) {
      log("ResetPassword: onValidateMailButtonTap: error: $e");
      customShowDialog(
        context: context,
        title: localizationManager.rpValidateMailErrorTitle,
        content: localizationManager.rpValidateMailErrorContent,
      );
      isValidateMailSent = false;
    }
  }

  void onVerifyCodeButtonTap() async {
    final String requestUrl = DotEnvManager().resetPasswordCodeVerify;

    try {
      final http.Response response = await Get.showOverlay(
        asyncFunction: () => http
            .post(
              Uri.parse(requestUrl),
              // headers: {
              //   "Content-Type": "application/json",
              // },
              body: {
                "studentId": idController.text,
                "authCode": validationCodeController.text,
              },
            )
            .timeout(const Duration(seconds: 10)),
        loadingWidget: const CustomCircularProgressIndicator(),
      );

      log("ResetPassword: onVerifyCodeButtonTap: response.body: ${response.body}");

      if (response.statusCode == 200) {
        if (jsonDecode(response.body) == true) {
          customShowDialog(
            context: context,
            title: localizationManager.rpVerifyCodeSuccessTitle,
            content: localizationManager.rpVerifyCodeSuccessContent,
          );
          isValidationCodeCorrect = true;
        } else {
          customShowDialog(
            context: context,
            title: localizationManager.rpVerifyCodeNotCorrectTitle,
            content: localizationManager.rpVerifyCodeNotCorrectContent,
          );
          isValidationCodeCorrect = false;
        }
      } else {
        customShowDialog(
          context: context,
          title: localizationManager.rpVerifyCodeFailedTitle,
          content: localizationManager.rpVerifyCodeFailedContent,
        );
        isValidationCodeCorrect = false;
      }
    } on TimeoutException {
      log("ResetPassword: onValidateMailButtonTap: TimeoutException");

      customShowDialog(
        context: context,
        title: localizationManager.errorsTimeout,
        content: localizationManager.errorsConnectionError,
      );

      isValidationCodeCorrect = false;
    } catch (e) {
      log("ResetPassword: onValidateMailButtonTap: error: $e");
      customShowDialog(
        context: context,
        title: localizationManager.rpVerifyCodeFailedTitle,
        content: localizationManager.rpVerifyCodeFailedContent,
      );
      isValidationCodeCorrect = false;
    }
  }

  void onBottomAppbarButtonTap() async {
    final String requestUrl = DotEnvManager().resetPassword;

    try {
      final http.Response response = await Get.showOverlay(
        asyncFunction: () => http
            .post(
              Uri.parse(requestUrl),
              headers: {
                "Content-Type": "application/json",
              },
              body: jsonEncode({
                "studentId": idController.text,
                "authCode": validationCodeController.text,
                "newPassword": newPasswordController.text
              }),
            )
            .timeout(
              const Duration(seconds: 10),
            ),
        loadingWidget: const CustomCircularProgressIndicator(),
      );

      if (response.statusCode == 200) {
        customShowDialog(
          context: context,
          title: localizationManager.rpResetPasswordSuccessTitle,
          content: localizationManager.rpResetPasswordSuccessContent,
          onTap: () {
            Get.find<PedometerController>().stopForegroundService();
            Get.find<PedometerController>().stopBackgroundService();
            Get.find<LocationController>().stopForegroundService();
            Get.find<LocationController>().stopBackgroundService();

            context.read<UserController>().add(SignOut());
            PrefsManager().clear();
            // NavigatorKeyManager().pushNamedAndRemoveUntil(RouteNames.signIn);
          },
        );
      } else {
        customShowDialog(
          context: context,
          title: localizationManager.rpResetPasswordUnknownErrorTitle,
          content: response.body,
        );
      }
    } on TimeoutException {
      customShowDialog(
        context: context,
        title: localizationManager.errorsTimeout,
        content: localizationManager.errorsConnectionError,
      );
    } catch (e) {
      log("ResetPassword: onBottomAppbarButtonTap: error: $e");
      customShowDialog(
        context: context,
        title: localizationManager.rpResetPasswordUnknownErrorTitle,
        content: localizationManager.rpResetPasswordUnknownErrorContent,
      );
    }
  }
}
