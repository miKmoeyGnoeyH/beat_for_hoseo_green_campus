import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:beat_flutter/components/global/methods/custom_show_dialog.dart';
import 'package:beat_flutter/components/global/widgets/appbars/custom_appbar.dart';
import 'package:beat_flutter/components/global/widgets/buttons/custom_bottom_appbar_button.dart';
import 'package:beat_flutter/components/global/widgets/buttons/custom_text_button.dart';
import 'package:beat_flutter/components/global/widgets/custom_circular_progress_indicator.dart';
import 'package:beat_flutter/components/global/widgets/custom_scaffold.dart';
import 'package:beat_flutter/components/global/widgets/custom_text_field.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_subtitle_large.dart';
import 'package:beat_flutter/controller/location/location_controller.dart';
import 'package:beat_flutter/controller/pedometer/pedometer_controller.dart';
import 'package:beat_flutter/controller/user_controller.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/dotenv/dotenv_manager.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:beat_flutter/managers/prefs/prefs_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  final int maxIdLength = 8;
  final int maxValidationCodeLength = 6;
  final int minPasswordLength = 8;

  bool isValidateMailButtonEnabled = false;
  bool isValidateMailSent = false;

  bool get _isSignUpButtonEnabled =>
      idController.text.length == maxIdLength &&
      validationCodeController.text.length == maxValidationCodeLength &&
      newPasswordController.text.length >= minPasswordLength &&
      passwordCheckController.text.length == newPasswordController.text.length;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: CustomScaffold(
        hasScrollBody: false,
        appBar: CustomAppBar(
          title: Text(localizationManager.rpAppbarTitle),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSubtitleLarge(
                    text: localizationManager.rpSidOrEmployeeId,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        flex: 6,
                        child: CustomTextField(
                          textEditingController: idController,
                          keyboardType: TextInputType.number,
                          maxLength: maxIdLength,
                          hintText: localizationManager.rpSidOrEmployeeIdHint,
                          obscureText: false,
                          onChanged: (value) {
                            if (value.length == 8) {
                              isValidateMailButtonEnabled = true;
                            } else {
                              isValidateMailButtonEnabled = false;
                            }
                            setState(() {});
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        flex: 4,
                        child: CustomTextButton(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 14,
                          ),
                          text: localizationManager.rpValidateMail,
                          // autoSizeText: true,
                          // maxLines: 1,
                          buttonColor: isValidateMailButtonEnabled
                              ? context.appColors.primary
                              : context.appColors.disabled,
                          onTap: isValidateMailButtonEnabled
                              ? () {
                                  FocusScope.of(context).unfocus();
                                  onValidateMailButtonTap();
                                }
                              : () {},
                        ),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSubtitleLarge(
                    text: localizationManager.rpValidationCode,
                  ),
                  CustomTextField(
                    textEditingController: validationCodeController,
                    maxLength: maxValidationCodeLength,
                    hintText: localizationManager.rpValidationCodeHint,
                    obscureText: false,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSubtitleLarge(
                    text: localizationManager.rpNewPassword,
                  ),
                  CustomTextField(
                    textEditingController: newPasswordController,
                    hintText: localizationManager.rpNewPasswordHint,
                    obscureText: true,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSubtitleLarge(
                    text: localizationManager.rfiPasswordCheck,
                  ),
                  CustomTextField(
                    textEditingController: passwordCheckController,
                    hintText: localizationManager.rfiPasswordCheckHint,
                    obscureText: true,
                  ),
                ],
              )
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomAppbarButton(
          onTap: _isSignUpButtonEnabled
              ? () {
                  FocusScope.of(context).unfocus();
                  onBottomAppbarButtonTap();
                }
              : () {
                  // FocusScope.of(context).unfocus();
                  // onBottomAppbarButtonTap();
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
          title: localizationManager.rpValidateMailSuccessTitle,
          content: localizationManager.rpValidateMailSuccessContent,
        );
      } else {
        customShowDialog(
          context: context,
          title: localizationManager.rpValidateMailErrorTitle,
          content: response.body,
        );
      }
    } on TimeoutException {
      log("ResetPassword: onValidateMailButtonTap: TimeoutException");

      customShowDialog(
        context: context,
        title: localizationManager.errorsTimeout,
        content: localizationManager.errorsConnectionError,
      );
    } catch (e) {
      log("ResetPassword: onValidateMailButtonTap: error: $e");
      customShowDialog(
        context: context,
        title: localizationManager.rpValidateMailErrorTitle,
        content: localizationManager.rpValidateMailErrorContent,
      );
    }
  }

  void onBottomAppbarButtonTap() async {
    final passwordRegex = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[^A-Za-z0-9])\S{8,}$',
    );
    if (!passwordRegex.hasMatch(newPasswordController.text)) {
      await customShowDialog(
        context: context,
        title: localizationManager.rpPasswordRuleErrorTitle,
        content: localizationManager.rpPasswordRuleErrorContent,
      );
      return;
    } else {
      if (newPasswordController.text != passwordCheckController.text) {
        await customShowDialog(
          context: context,
          title: localizationManager.rpPasswordMismatchTitle,
          content: localizationManager.rpPasswordMismatchContent,
        );
        return;
      }
    }

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
            context.read<UserController>().add(SignOut());

            Get.find<PedometerController>().stopForegroundService();
            Get.find<PedometerController>().stopBackgroundService();
            Get.find<LocationController>().stopForegroundService();
            Get.find<LocationController>().stopBackgroundService();

            PrefsManager().resetSavedStudentIdAndPassword();
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
