import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:beat_flutter/components/global/widgets/custom_circular_progress_indicator.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
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

  late final int maxIDLength;

  @override
  void initState() {
    maxIDLength = registerOrganizationController!.organization ==
            localizationManager.generalStudent
        ? 8
        : 8;
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
            if (state is IDSent) {
              customShowDialog(
                context: context,
                title: localizationManager.rfiEmailSentTitle,
                // registerOrganizationController!.organization ==
                //         localizationManager.generalStudent
                //     ? localizationManager.rfiEmailSentTitle
                //     : localizationManager.rfiIdCheckTitle,
                content: localizationManager.rfiEmailSentMessage,
                // registerOrganizationController!.organization ==
                //         localizationManager.generalStudent
                //     ? localizationManager.rfiEmailSentMessage
                //     : localizationManager.rfiIdCheckMessage,
              );
            } else if (state is IDError) {
              _isEmailButtonEnabled = true;
              customShowDialog(
                context: context,
                title: localizationManager.rfiEmailSentErrorTitle,
                // registerOrganizationController!.organization ==
                //         localizationManager.generalStudent
                //     ? localizationManager.rfiEmailSentErrorTitle
                //     : localizationManager.rfiIdCheckErrorTitle,
                content: state.msg,
                // registerOrganizationController!.organization ==
                //         localizationManager.generalStudent
                //     ? localizationManager.rfiEmailSentErrorMessage
                //     : localizationManager.rfiIdCheckErrorMessage,
              );
            }
          },
        ),
        BlocListener<RegisterNicknameController, NicknameState>(
          listener: (context, state) {
            if (state is NicknameChecked) {
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
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
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
                  const SizedBox(height: 20),
                  // 이름
                  RegisterNameTextField(
                    registerNameController: registerNameController,
                    onChanged: validateName,
                  ),
                  const SizedBox(height: 20),
                  // 닉네임
                  CustomSubtitleLarge(text: localizationManager.rfiNickname),
                  Row(
                    children: [
                      RegisterNicknameTextField(
                        registerNicknameController: registerNicknameController,
                        onChanged: (value) {
                          registerNicknameController.add(NicknameChanged());
                          if (value.length >= 2) {
                            _isNicknameButtonEnabled = true;
                          } else {
                            _isNicknameButtonEnabled = false;
                          }
                          setState(() {});
                        },
                      ),
                      const SizedBox(width: 10),
                      BlocBuilder<RegisterNicknameController, NicknameState>(
                        builder: (context, state) => Flexible(
                          child: CustomWideButton(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            onTap: _isNicknameButtonEnabled
                                ? () async {
                                    FocusScope.of(context).unfocus();
                                    final String text =
                                        registerNicknameController
                                            .nicknameController.text;
                                    // 닉네임에 초성이 포함된 경우
                                    if (RegExp(r'[ㅏ-ㅣㄱ-ㅎ]').hasMatch(text)) {
                                      customShowDialog(
                                        context: context,
                                        title: localizationManager
                                            .rfiInappropriateNickname,
                                        content: localizationManager
                                            .rfiNicknameHasInitialConsonant,
                                      );
                                    }
                                    // 닉네임에 비속어가 포함된 경우
                                    else if (customProfanityFilter
                                        .hasMatch(text)) {
                                      customShowDialog(
                                        context: context,
                                        title: localizationManager
                                            .rfiInappropriateNickname,
                                        content: localizationManager
                                            .rfiInappropriateNicknameMessage,
                                      );
                                    } else {
                                      _isNicknameButtonEnabled = false;
                                      registerNicknameController
                                          .add(NicknameRequest());
                                    }
                                  }
                                : () {},
                            buttonText: state is NicknameChecked
                                ? localizationManager.rfiNicknameChecked
                                : localizationManager.rfiValidateNickname,
                            buttonColor: _isNicknameButtonEnabled
                                ? context.appColors.primary
                                : context.appColors.disabled,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // 학번
                  CustomSubtitleLarge(
                    text: localizationManager.rfiSidOrEmployeeId,
                    // registerOrganizationController!.organization ==
                    //         localizationManager.generalStudent
                    //     ? localizationManager.rfiStudentId
                    //     : localizationManager.rfiId,
                  ),
                  Row(
                    children: [
                      RegisterSIDTextField(
                          maxLength: maxIDLength,
                          registerSidController: registerSidController,
                          hintText: localizationManager.rfiSidOrEmployeeIdHint,
                          // registerOrganizationController!.organization ==
                          //         localizationManager.generalStudent
                          //     ? localizationManager.rfiStudentIdHint
                          //     : localizationManager.rfiIdHint,
                          onChanged: (value) {
                            registerSidController.add(IDChanged());
                            if (value.length >= maxIDLength) {
                              _isEmailButtonEnabled = true;
                            } else {
                              _isEmailButtonEnabled = false;
                            }
                            setState(() {});
                          }),
                      const SizedBox(width: 10),
                      BlocBuilder<RegisterIDController, IDState>(
                        builder: (context, state) => Flexible(
                          child: CustomWideButton(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            onTap: _isEmailButtonEnabled
                                ? () async {
                                    _isEmailButtonEnabled = false;
                                    registerSidController.add(
                                      EmailRequest(
                                        registerSidController.idController.text,
                                        category,
                                      ),
                                    );
                                    // if (registerOrganizationController!
                                    //         .organization ==
                                    //     localizationManager.generalStudent) {
                                    //   registerSidController.add(EmailRequest());
                                    // } else {
                                    //   registerSidController.add(IDRequest());
                                    // }
                                  }
                                : () {},
                            buttonText:
                                registerOrganizationController!.organization ==
                                        localizationManager.generalStudent
                                    ? localizationManager.rfiValidateMail
                                    : localizationManager.rfiValidateId,
                            buttonColor: _isEmailButtonEnabled
                                ? context.appColors.primary
                                : context.appColors.disabled,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  RegisterPasswordTextField(
                    registerPasswordController: passwordController,
                    onChanged: null,
                  ),
                  const SizedBox(height: 20),
                  RegisterPasswordCheckTextField(
                    registerPasswordCheckController: passwordCheckController,
                    onChanged: null,
                  ),
                  const SizedBox(height: 20),
                  CustomSubtitleLarge(
                      text: localizationManager.rfiWhyDoINeedToSign),
                  const SizedBox(height: 10),
                  CustomBodyLarge(text: localizationManager.rfiWdintsContent),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
                  SignPreview(registerSignController: registerSignController),
                  const SizedBox(height: 20),
                  TermsOfAgreement(
                    registerAgreementController: registerAgreementController,
                    setIsAgreementChecked: setIsAgreementChecked,
                  ),
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
                    sidState is IDSent &&
                    nicknameState is NicknameChecked &&
                    registerAgreementController.isAgreementChecked;

                return CustomBottomAppbarButton(
                  onTap:
                      // _isSignUpButtonEnabled
                      //     ?
                      () async {
                    _isSignUpButtonEnabled = false;
                    final UserProvider userProvider = UserProvider();
                    final String studentId =
                        registerSidController.idController.text;
                    final String name =
                        registerNameController.nameController.text;
                    final String nickname =
                        registerNicknameController.nicknameController.text;
                    final String department = context.deviceLocale.toString() ==
                            "ko_KR"
                        ? registerDepartmentController!.department
                        : context.tr(registerDepartmentController!.department);

                    final passwordRegex = RegExp(
                      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[^A-Za-z0-9])\S{8,}$',
                    );
                    if (!passwordRegex.hasMatch(passwordController.text)) {
                      await customShowDialog(
                        context: context,
                        title: localizationManager.rfiPasswordRuleErrorTitle,
                        content:
                            localizationManager.rfiPasswordRuleErrorContent,
                      );
                      return;
                    } else {
                      if (passwordController.text !=
                          passwordCheckController.text) {
                        await customShowDialog(
                          context: context,
                          title: localizationManager.rfiPasswordMismatchTitle,
                          content:
                              localizationManager.rfiPasswordMismatchContent,
                        );
                        return;
                      }
                    }

                    if (!registerSignController.handSignatureControl.isFilled) {
                      await customShowDialog(
                        context: context,
                        title: localizationManager.rfiSignIsEmptyTitle,
                        content: localizationManager.rfiSignIsEmptyContent,
                      );
                      return;
                    }

                    final String email =
                        "${registerSidController.idController.text}$mailDomain";
                    final ByteData? signature = await registerSignController
                        .handSignatureControl
                        .toImage(background: Colors.transparent);
                    final String encodedSignFile =
                        base64Encode(signature!.buffer.asUint8List());

                    try {
                      final http.Response response = await Get.showOverlay(
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
                        loadingWidget: const CustomCircularProgressIndicator(),
                      );
                      if (response.statusCode == 200) {
                        if (context.mounted) {
                          customShowDialog(
                            context: context,
                            title: localizationManager.rfiSignUpSuccess,
                            content:
                                localizationManager.rfiSignUpSuccessMessage,
                            buttonText: localizationManager.rfiToSignInScreen,
                            onTap: () {
                              NavigatorKeyManager()
                                  .pushNamedAndRemoveUntil(RouteNames.signIn);
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
                          content: localizationManager.rfiSignUpFailedMessage,
                        );
                        _isSignUpButtonEnabled = true;
                      }
                    }
                  },
                  // : () {},
                  backgroundColor: _isSignUpButtonEnabled
                      ? context.appColors.primary
                      : context.appColors.disabled,
                  text: localizationManager.rfiSignUp,
                  textColor: _isSignUpButtonEnabled
                      ? context.appColors.onPrimary
                      : context.appColors.onBackground,
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
    if (!RegExp(r'[ㅏ-ㅣㄱ-ㅎ]').hasMatch(value)) {
      _isNameValid = true;
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
}
