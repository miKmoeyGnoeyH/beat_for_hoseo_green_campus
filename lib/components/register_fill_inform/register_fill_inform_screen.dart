import 'package:Beat/extensions/buildcontext_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
import 'widgets/register_nickname_textfield.dart';
import 'widgets/register_sid_textfield.dart';
import 'widgets/org_col_dep_indicator.dart';
import 'widgets/register_name_text_field.dart';
import 'widgets/sign_preview.dart';
import 'widgets/terms_of_agreement.dart';

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

  @override
  Widget build(BuildContext context) {
    final RegisterSidController registerSidController =
        context.read<RegisterSidController>();

    final RegisterNicknameController registerNicknameController =
        context.read<RegisterNicknameController>();

    return MultiBlocListener(
      listeners: [
        BlocListener<RegisterSidController, EmailState>(
          listener: (context, state) {
            if (state is EmailSent) {
              customShowDialog(
                context: context,
                title: context.tr('email_sent'),
                content: context.tr('email_sent_message'),
              );
            } else if (state is EmailError) {
              _isEmailButtonEnabled = true;
              customShowDialog(
                context: context,
                title: context.tr('email_sent_error'),
                content: context.tr('email_sent_error_message'),
              );
            }
          },
        ),
        BlocListener<RegisterNicknameController, NicknameState>(
          listener: (context, state) {
            if (state is NicknameChecked) {
              customShowDialog(
                context: context,
                title: context.tr('nickname_checked'),
                content: context.tr('nickname_checked_message'),
              );
            } else if (state is NicknameAlreadyTaken) {
              _isNicknameButtonEnabled = true;
              customShowDialog(
                context: context,
                title: context.tr('nickname_unchecked'),
                content: context.tr('nickname_unchecked_message'),
              );
            } else if (state is NicknameError) {
              _isNicknameButtonEnabled = true;
              customShowDialog(
                context: context,
                title: context.tr('nickname_check_error'),
                content: context.tr('nickname_check_error_message'),
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
            text: context.tr('register_fill_inform'),
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
                  RegisterNameTextField(
                    registerNameController: registerNameController,
                    onChanged: validateName,
                  ),
                  const SizedBox(height: 20),
                  CustomSubtitleLarge(text: context.tr('student_id')),
                  Row(
                    children: [
                      RegisterSIDTextField(
                          registerSidController: registerSidController,
                          onChanged: (value) {
                            registerSidController.add(EmailChanged());
                            if (value.length >= 8) {
                              _isEmailButtonEnabled = true;
                            } else {
                              _isEmailButtonEnabled = false;
                            }
                            setState(() {});
                          }),
                      const SizedBox(width: 10),
                      BlocBuilder<RegisterSidController, EmailState>(
                        builder: (context, state) => Flexible(
                          child: CustomWideButton(
                            onTap: _isEmailButtonEnabled
                                ? () {
                                    _isEmailButtonEnabled = false;
                                    registerSidController.add(EmailRequest());
                                  }
                                : () {},
                            buttonText: context.tr('validate_mail'),
                            buttonColor: _isEmailButtonEnabled
                                ? context.appColors.primary
                                : context.appColors.disabled,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomSubtitleLarge(text: context.tr('nickname')),
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
                            onTap: _isNicknameButtonEnabled
                                ? () async {
                                    final String text =
                                        registerNicknameController
                                            .nicknameController.text;
                                    // 닉네임에 초성이 포함된 경우
                                    if (RegExp(r'[ㅏ-ㅣㄱ-ㅎ]').hasMatch(text)) {
                                      customShowDialog(
                                          context: context,
                                          title: context
                                              .tr('inapropriate_nickname'),
                                          content: context.tr(
                                              'nickname_has_initial_consonant'));
                                    }
                                    // 닉네임에 비속어가 포함된 경우
                                    else if (customProfanityFilter
                                        .hasMatch(text)) {
                                      customShowDialog(
                                          context: context,
                                          title: context
                                              .tr('inapropriate_nickname'),
                                          content: context.tr(
                                              'inapropriate_nickname_message'));
                                    } else {
                                      _isNicknameButtonEnabled = false;
                                      registerNicknameController
                                          .add(NicknameRequest());
                                    }
                                  }
                                : () {},
                            buttonText: context.tr('validate_nickname'),
                            buttonColor: _isNicknameButtonEnabled
                                ? context.appColors.primary
                                : context.appColors.disabled,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomSubtitleLarge(
                      text: context.tr('why_do_i_need_to_sign')),
                  const SizedBox(height: 10),
                  CustomBodyLarge(text: context.tr('wdints_content')),
                  const SizedBox(height: 20),
                  CustomWideButton(
                    onTap: () => NavigatorKeyManager().pushNamed(
                      RouteNames.registerSign,
                      arguments: RegisterSignArguments(
                        registerSignController,
                      ),
                    ),
                    buttonText: context.tr('sign'),
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
          bottomNavigationBar: BlocBuilder<RegisterSidController, EmailState>(
            builder: (context, sidState) =>
                BlocBuilder<RegisterNicknameController, NicknameState>(
              builder: (context, nicknameState) {
                _isSignUpButtonEnabled = _isNameValid &&
                    sidState is EmailSent &&
                    nicknameState is NicknameChecked &&
                    registerAgreementController.isAgreementChecked;

                return CustomBottomAppbarButton(
                  onTap: _isSignUpButtonEnabled
                      ? () async {
                          _isSignUpButtonEnabled = false;
                          final UserProvider userProvider = UserProvider();
                          final String studentId =
                              registerSidController.sidController.text;
                          final String name =
                              registerNameController.nameController.text;
                          final String nickname = registerNicknameController
                              .nicknameController.text;
                          final String department =
                              context.deviceLocale.toString() == "ko_KR"
                                  ? registerDepartmentController!.department
                                  : context.tr(
                                      registerDepartmentController!.department);
                          await userProvider
                              .signUp(studentId, name, nickname, department)
                              .then(
                                (result) => {
                                  if (result == 200)
                                    {
                                      if (context.mounted)
                                        {
                                          customShowDialog(
                                              context: context,
                                              title:
                                                  context.tr('sign_up_success'),
                                              content: context.tr(
                                                  'sign_up_success_message'),
                                              buttonText: context
                                                  .tr('to_sign_in_screen'),
                                              onTap: () {
                                                NavigatorKeyManager()
                                                    .pushNamedAndRemoveUntil(
                                                        RouteNames.signIn);
                                              })
                                        }
                                    }
                                  else
                                    {
                                      if (context.mounted)
                                        {
                                          customShowDialog(
                                            context: context,
                                            title: context.tr('sign_up_failed'),
                                            content: context
                                                .tr('sign_up_failed_message'),
                                          ),
                                          _isSignUpButtonEnabled = true,
                                        }
                                    }
                                },
                              );
                        }
                      : () {},
                  backgroundColor: _isSignUpButtonEnabled
                      ? context.appColors.primary
                      : context.appColors.disabled,
                  text: context.tr('sign_up'),
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
