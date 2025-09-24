import 'dart:convert';

import 'package:beat_flutter/components/global/methods/custom_input_formatters.dart';
import 'package:beat_flutter/components/global/widgets/custom_circular_progress_indicator.dart';
import 'package:beat_flutter/components/global/widgets/custom_text_field.dart';
import 'package:beat_flutter/components/register_fill_inform/widgets/rfi_regexp.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../controller/register/register_college_controller.dart';
import '../../controller/register/register_department_controller.dart';
import '../../controller/register_fill_inform/register_agreement_controller.dart';
import '../../controller/register_fill_inform/register_name_controller.dart';
import '../../controller/register_fill_inform/register_nickname_controller.dart';
import '../../controller/register/register_organization_controller.dart';
import '../../controller/register_fill_inform/register_sid_controller.dart';
import '../../controller/register_fill_inform/register_sign_controller.dart';
import '../../data/provider/user_provider.dart';
import '../../data/states/email_state.dart';
import '../../data/states/nickname_state.dart';
import '../../managers/navigator/arguments/register_arguments.dart';
import '../../managers/navigator/arguments/register_sign_arguments.dart';
import '../../managers/navigator/navigator_key_manager.dart';
import '../../managers/navigator/routes.dart';
import '../global/methods/custom_show_dialog.dart';
import '../global/widgets/buttons/custom_bottom_appbar_button.dart';
import '../global/widgets/buttons/custom_wide_button.dart';
import '../global/widgets/texts/custom_body_large.dart';
import '../global/widgets/regexp/custom_profanity_filter.dart';
import '../global/widgets/custom_scaffold.dart';
import '../global/widgets/texts/custom_subtitle_large.dart';
import '../register_organization/widgets/register_organization_appbar.dart';
import 'widgets/index.dart';

class RegisterFillInformScreen extends StatefulWidget {
  const RegisterFillInformScreen(this.registerArguments, {super.key});

  final RegisterArguments registerArguments;

  @override
  State<RegisterFillInformScreen> createState() =>
      _RegisterFillInformScreenState();
}

class _RegisterFillInformScreenState extends State<RegisterFillInformScreen> {
  final RegisterNameController registerNameController =
      RegisterNameController();

  final RegisterSignController registerSignController =
      RegisterSignController();

  final RegisterAgreementController registerAgreementController =
      RegisterAgreementController();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordCheckController = TextEditingController();

  final LocalizationManager localizationManager = LocalizationManager();

  late final int? maxIDLength;

  @override
  void initState() {
    maxIDLength = registerOrganizationController!.organization ==
            localizationManager.generalStudent
        ? 8
        : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final RegisterIDController registerSidController =
        context.read<RegisterIDController>();

    final RegisterNicknameController registerNicknameController =
        context.read<RegisterNicknameController>();

    return MultiBlocListener(
      listeners: [
        BlocListener<RegisterIDController, IDState>(
          listener: (context, state) {
            if (Get.isDialogOpen == true) Get.back();

            if (state is IDSent) {
              _isCheckEmailVerifyButtonEnabled = true;
              customShowDialog(
                context: context,
                title: localizationManager.rfiEmailSentTitle,
                content: localizationManager.rfiEmailSentMessage,
              );
            } else if (state is IDError) {
              _isEmailButtonEnabled = true;
              customShowDialog(
                context: context,
                title: localizationManager.rfiEmailSentErrorTitle,
                content: state.msg,
              );
            } else if (state is IDSending || state is IDEmailChecking) {
              Get.dialog(const CustomCircularProgressIndicator());
            } else if (state is IDEmailChecked) {
              _isCheckEmailVerifyButtonEnabled = false;
              customShowDialog(
                context: context,
                title: localizationManager.rfiEmailCheckSuccessTitle,
                content: localizationManager.rfiEmailCheckSuccessContent,
              );
            } else if (state is IDEmailNotChecked) {
              _isCheckEmailVerifyButtonEnabled = true;
              customShowDialog(
                context: context,
                title: localizationManager.rfiEmailNotCheckTitle,
                content: localizationManager.rfiEmailNotCheckContent,
              );
            } else if (state is IDEmailCheckError) {
              _isCheckEmailVerifyButtonEnabled = true;
              customShowDialog(
                context: context,
                title: localizationManager.rfiEmailCheckFailedTitle,
                content: localizationManager.rfiEmailCheckFailedContent,
              );
            }
          },
        ),
        BlocListener<RegisterNicknameController, NicknameState>(
          listener: (context, state) {
            if (Get.isDialogOpen == true) Get.back();

            if (state is NicknameChecked) {
              _isNicknameButtonEnabled = false;
              customShowDialog(
                context: context,
                title: localizationManager.rfiNicknameCheckedTitle,
                content: localizationManager.rfiNicknameCheckedMessage,
              );
            } else if (state is NicknameAlreadyTaken) {
              _isNicknameButtonEnabled = true;
              customShowDialog(
                context: context,
                title: localizationManager.rfiNicknameUncheckedTitle,
                content: localizationManager.rfiNicknameUncheckedMessage,
              );
            } else if (state is NicknameError) {
              _isNicknameButtonEnabled = true;
              customShowDialog(
                context: context,
                title: localizationManager.rfiNicknameCheckErrorTitle,
                content: localizationManager.rfiNicknameCheckErrorMessage,
              );
            } else if (state is NicknameChecking) {
              Get.dialog(const CustomCircularProgressIndicator());
            }
          },
        )
      ],
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        onTapDown: (_) => FocusScope.of(context).unfocus(),
        child: CustomScaffold(
          backgroundColor: context.appColors.background,
          appBar: RegisterBasicAppbar(
            text: localizationManager.rfiAppbarTitle,
          ),
          body: Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 10.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OrgColDepIndicator(
                    orgText: registerOrganizationController!.organization,
                    colText: registerCollegeController != null
                        ? registerCollegeController!.college
                        : '',
                    depText: registerDepartmentController != null
                        ? registerDepartmentController!.department
                        : '',
                  ),
                  SizedBox(height: 35.w),
                  // 이름
                  CustomTextField(
                    textEditingController:
                        registerNameController.nameController,
                    labelText: localizationManager.rfiName,
                    hintText: localizationManager.rfiNameHint,
                    inputFormatters: [onlyEnglishAndKoreanInputFormatter()],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        _isNameValid = false;
                        return localizationManager.rfiNameIsEmpty;
                      } else if (initialConsonantRegExp.hasMatch(value)) {
                        _isNameValid = false;
                        return localizationManager.rfiNameHasInitialConsonant;
                      } else if (customProfanityFilter.hasMatch(value)) {
                        _isNameValid = false;
                        return localizationManager.rfiInavailableNameMessage;
                      }
                      _isNameValid = true;
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  // RegisterNameTextField(
                  //   registerNameController: registerNameController,
                  // ),
                  SizedBox(height: 35.w),
                  // 닉네임
                  CustomTextField(
                    textEditingController:
                        registerNicknameController.nicknameController,
                    labelText: localizationManager.rfiNickname,
                    hintText: localizationManager.rfiNicknameHint,
                    maxLength: 10,
                    inputFormatters: [
                      onlyEnglishAndKoreanAndNumberInputFormatter()
                    ],
                    onChanged: (value) {
                      registerNicknameController.add(NicknameChanged());
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        _isNicknameButtonEnabled = false;
                        return localizationManager.rfiNicknameIsEmpty;
                      } else if (value.length < 2) {
                        _isNicknameButtonEnabled = false;
                        return localizationManager.rfiNicknameTooShort;
                      } else if (initialConsonantRegExp.hasMatch(value)) {
                        _isNicknameButtonEnabled = false;
                        return localizationManager
                            .rfiNicknameHasInitialConsonant;
                      } else if (customProfanityFilter.hasMatch(value)) {
                        _isNicknameButtonEnabled = false;
                        return localizationManager
                            .rfiInappropriateNicknameMessage;
                      }
                      _isNicknameButtonEnabled = true;
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    actions: [
                      BlocBuilder<RegisterNicknameController, NicknameState>(
                        builder: (context, state) => CustomWideButton(
                          width: 120.w,
                          height: 50.w,
                          autoSizeText: true,
                          borderRadius: 10,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 10.w,
                          ),
                          onTap: (state is NicknameChecked)
                              ? () {}
                              : _isNicknameButtonEnabled
                                  ? () async {
                                      FocusScope.of(context).unfocus();
                                      _isNicknameButtonEnabled = false;
                                      registerNicknameController
                                          .add(NicknameRequest());
                                    }
                                  : () {},
                          buttonText: state is NicknameChecked
                              ? localizationManager.rfiNicknameChecked
                              : localizationManager.rfiValidateNickname,
                          buttonColor: (state is NicknameChecked)
                              ? context.appColors.disabled
                              : _isNicknameButtonEnabled
                                  ? context.appColors.primary
                                  : context.appColors.disabled,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 35.w),
                  // TODO: 학생이면 8자리 학번, 교직원은 꼭 교번이 아닐 수 있음
                  // 학번
                  CustomTextField(
                    textEditingController: registerSidController.idController,
                    labelText: registerOrganizationController!.organization ==
                            localizationManager.generalStudent
                        ? localizationManager.rfiStudentId
                        : localizationManager.rfiEmployeeMail,
                    hintText: registerOrganizationController!.organization ==
                            localizationManager.generalStudent
                        ? localizationManager.rfiStudentIdHint
                        : localizationManager.rfiEmployeeMailHint,
                    keyboardType:
                        registerOrganizationController!.organization ==
                                localizationManager.generalStudent
                            ? TextInputType.number
                            : null,
                    maxLength: maxIDLength,
                    inputFormatters:
                        registerOrganizationController!.organization ==
                                localizationManager.generalStudent
                            ? [onlyDigitsInputFormatter()]
                            : [denySpaceFormatter()],
                    onChanged: (value) {
                      registerSidController.add(IDChanged());
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        _isEmailButtonEnabled = false;
                        return localizationManager.rfiMailIsEmpty;
                      }
                      if (registerOrganizationController!.organization ==
                          localizationManager.generalStudent) {
                        if (value.length < maxIDLength!) {
                          _isEmailButtonEnabled = false;
                          return localizationManager.rfiSidTooShort;
                        }
                      } else {
                        if (!emailRegExp.hasMatch(value)) {
                          _isEmailButtonEnabled = false;
                          return localizationManager.rfiInvalidMailContent;
                        }
                      }
                      _isEmailButtonEnabled = true;
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    actions: [
                      BlocBuilder<RegisterIDController, IDState>(
                        builder: (context, state) => CustomWideButton(
                          width: 120.w,
                          height: 50.w,
                          autoSizeText: true,
                          borderRadius: 10,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 10.w,
                          ),
                          onTap: (state is IDSent ||
                                  state is IDEmailChecking ||
                                  state is IDEmailChecked ||
                                  state is IDEmailNotChecked ||
                                  state is IDEmailCheckError)
                              ? () {}
                              : _isEmailButtonEnabled
                                  ? () async {
                                      FocusScope.of(context).unfocus();
                                      _isEmailButtonEnabled = false;
                                      registerSidController.add(
                                        EmailRequest(
                                          registerSidController
                                              .idController.text,
                                          category,
                                        ),
                                      );
                                    }
                                  : () {},
                          buttonText: (state is IDSent ||
                                  state is IDEmailChecking ||
                                  state is IDEmailChecked ||
                                  state is IDEmailNotChecked ||
                                  state is IDEmailCheckError)
                              ? localizationManager.rfiMailSent
                              : localizationManager.rfiValidateMail,
                          buttonColor: (state is IDSent ||
                                  state is IDEmailChecking ||
                                  state is IDEmailChecked ||
                                  state is IDEmailNotChecked ||
                                  state is IDEmailCheckError)
                              ? context.appColors.disabled
                              : _isEmailButtonEnabled
                                  ? context.appColors.primary
                                  : context.appColors.disabled,
                        ),
                      ),
                    ],
                  ),
                  BlocBuilder<RegisterIDController, IDState>(
                    builder: (context, state) {
                      if (state is IDSent ||
                          state is IDEmailChecking ||
                          state is IDEmailChecked ||
                          state is IDEmailNotChecked ||
                          state is IDEmailCheckError) {
                        return SizedBox(
                          height: 20.w,
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                  BlocBuilder<RegisterIDController, IDState>(
                    builder: (context, state) {
                      if (state is IDSent ||
                          state is IDEmailChecking ||
                          state is IDEmailChecked ||
                          state is IDEmailNotChecked ||
                          state is IDEmailCheckError) {
                        return CustomWideButton(
                          borderRadius: 10,
                          buttonText: (state is IDEmailChecked)
                              ? localizationManager.rfiEmailVerified
                              : localizationManager.rfiCheckMailVerify,
                          buttonColor: _isCheckEmailVerifyButtonEnabled
                              ? context.appColors.primary
                              : context.appColors.disabled,
                          onTap: _isCheckEmailVerifyButtonEnabled
                              ? () {
                                  FocusScope.of(context).unfocus();
                                  _isCheckEmailVerifyButtonEnabled = false;
                                  registerSidController.add(
                                    EmailVerify(
                                        "${registerSidController.idController.text}$mailDomain"),
                                  );
                                }
                              : () {},
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                  SizedBox(height: 35.w),
                  CustomTextField(
                    textEditingController: passwordController,
                    labelText: localizationManager.rfiPassword,
                    hintText: localizationManager.rfiPasswordHint,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localizationManager.rfiPasswordIsEmpty;
                      }
                      if (!passwordRegex.hasMatch(value)) {
                        return localizationManager.rfiPasswordRuleErrorContent;
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  SizedBox(height: 35.w),
                  CustomTextField(
                    labelText: localizationManager.rfiPasswordCheck,
                    hintText: localizationManager.rfiPasswordCheckHint,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        _isPasswordValid = false;
                        return localizationManager.rfiPasswordCheckIsEmpty;
                      } else if (value != passwordController.text) {
                        _isPasswordValid = false;
                        return localizationManager.rfiPasswordMismatchContent;
                      }
                      _isPasswordValid = true;
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  SizedBox(height: 35.w),
                  CustomSubtitleLarge(
                      text: localizationManager.rfiWhyDoINeedToSign),
                  SizedBox(height: 10.w),
                  CustomBodyLarge(text: localizationManager.rfiWdintsContent),
                  SizedBox(height: 35.w),
                  CustomWideButton(
                    onTap: () => NavigatorKeyManager().pushNamed(
                      RouteNames.registerSign,
                      arguments: RegisterSignArguments(
                        registerSignController,
                      ),
                    ),
                    buttonText: localizationManager.rfiSign,
                    buttonColor: context.appColors.primary,
                  ),
                  SizedBox(height: 35.w),
                  SignPreview(registerSignController: registerSignController),
                  SizedBox(height: 35.w),
                  TermsOfAgreement(
                    registerAgreementController: registerAgreementController,
                    setIsAgreementChecked: setIsAgreementChecked,
                  ),
                  SizedBox(height: 35.w),
                  // const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BlocBuilder<RegisterIDController, IDState>(
            builder: (context, sidState) =>
                BlocBuilder<RegisterNicknameController, NicknameState>(
              builder: (context, nicknameState) {
                _isSignUpButtonEnabled = _isNameValid &&
                    nicknameState is NicknameChecked &&
                    sidState is IDEmailChecked &&
                    _isPasswordValid &&
                    registerSignController.handSignatureControl.isFilled &&
                    registerAgreementController.isAgreementChecked;

                return CustomBottomAppbarButton(
                  onTap: _isSignUpButtonEnabled
                      ? () async {
                          _isSignUpButtonEnabled = false;
                          final UserProvider userProvider = UserProvider();
                          final String studentId =
                              registerSidController.idController.text;
                          final String name =
                              registerNameController.nameController.text;
                          final String nickname = registerNicknameController
                              .nicknameController.text;
                          // final String department =
                          //     context.deviceLocale.toString() == "ko_KR"
                          //         ? registerDepartmentController!.department
                          //         : context.tr(
                          //             registerDepartmentController!.department);

                          if (!registerSignController
                              .handSignatureControl.isFilled) {
                            await customShowDialog(
                              context: context,
                              title: localizationManager.rfiSignIsEmptyTitle,
                              content:
                                  localizationManager.rfiSignIsEmptyContent,
                            );
                            return;
                          }

                          final String email =
                              registerSidController.idController.text;
                          final ByteData? signature =
                              await registerSignController.handSignatureControl
                                  .toImage(background: Colors.transparent);
                          final String encodedSignFile =
                              base64Encode(signature!.buffer.asUint8List());

                          try {
                            final http.Response response =
                                await Get.showOverlay(
                              asyncFunction: () {
                                return userProvider.signUp(
                                  category,
                                  registerDepartmentController!.department,
                                  studentId,
                                  email,
                                  name,
                                  nickname,
                                  passwordController.text,
                                  encodedSignFile,
                                );
                              },
                              loadingWidget:
                                  const CustomCircularProgressIndicator(),
                            );
                            if (response.statusCode == 200) {
                              if (context.mounted) {
                                customShowDialog(
                                  context: context,
                                  title: localizationManager.rfiSignUpSuccess,
                                  content: localizationManager
                                      .rfiSignUpSuccessMessage,
                                  buttonText:
                                      localizationManager.rfiToSignInScreen,
                                  onTap: () {
                                    NavigatorKeyManager()
                                        .pushNamedAndRemoveUntil(
                                            RouteNames.signIn);
                                  },
                                );
                              }
                            } else {
                              if (context.mounted) {
                                customShowDialog(
                                  context: context,
                                  title: localizationManager.rfiSignUpFailed,
                                  content: response.body,
                                );
                              }
                            }
                          } catch (e) {
                            if (context.mounted) {
                              customShowDialog(
                                context: context,
                                title: localizationManager.rfiSignUpFailed,
                                content:
                                    localizationManager.rfiSignUpFailedMessage,
                              );
                              _isSignUpButtonEnabled = true;
                            }
                          }
                        }
                      : () {},
                  // : () {},
                  backgroundColor: _isSignUpButtonEnabled
                      ? context.appColors.primary
                      : context.appColors.disabled,
                  text: localizationManager.rfiSignUp,
                  textColor: _isSignUpButtonEnabled
                      ? context.appColors.onPrimary
                      : context.appColors.disabledTextColor,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  String get mailDomain {
    if (registerOrganizationController!.organization ==
        localizationManager.roStudent) {
      return "@vision.hoseo.edu";
    } else if (registerOrganizationController!.organization ==
        localizationManager.roFacultyAndStaff) {
      return "@hoseo.edu";
    } else {
      return "@vision.hoseo.edu";
    }
  }

  String get category {
    if (registerOrganizationController!.organization ==
        localizationManager.roStudent) {
      return "STUDENT";
    } else if (registerOrganizationController!.organization ==
        localizationManager.roFacultyAndStaff) {
      return "EMPLOYEE";
    } else {
      return "STUDENT";
    }
  }

  void setIsAgreementChecked(bool value) {
    registerAgreementController.isAgreementChecked = value;
    setState(() {});
  }

  void validateName(String value) {
    if (value.isNotEmpty) {
      if (!RegExp(r'[ㅏ-ㅣㄱ-ㅎ]').hasMatch(value)) {
        _isNameValid = true;
      } else {
        _isNameValid = false;
      }
    } else {
      _isNameValid = false;
    }
    setState(() {});
  }

  RegisterOrganizationController? get registerOrganizationController =>
      widget.registerArguments.registerOrganizationController;

  RegisterCollegeController? get registerCollegeController =>
      widget.registerArguments.registerCollegeController;

  RegisterDepartmentController? get registerDepartmentController =>
      widget.registerArguments.registerDepartmentController;

  bool _isNameValid = false;
  bool _isEmailButtonEnabled = false;
  bool _isNicknameButtonEnabled = false;
  bool _isSignUpButtonEnabled = false;
  bool _isPasswordValid = false;
  bool _isCheckEmailVerifyButtonEnabled = false;
}
