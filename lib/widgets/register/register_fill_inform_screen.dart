import 'dart:developer';

import 'package:BEAT/controller/register/register_name_controller.dart';
import 'package:BEAT/controller/register/register_sid_controller.dart';
import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:BEAT/managers/navigator/navigator_key_manager.dart';
import 'package:BEAT/managers/navigator/routes.dart';
import 'package:BEAT/widgets/global/custom_rounded_bordered_container.dart';
import 'package:BEAT/widgets/global/custom_scaffold.dart';
import 'package:BEAT/widgets/global/custom_profanity_filter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controller/register/register_agreement_controller.dart';
import '../../controller/register/register_nickname_controller.dart';
import '../../controller/register/register_organization_controller.dart';
import '../../controller/register/register_sign_controller.dart';
import '../../data/models/email_state.dart';
import '../../data/models/nickname_state.dart';
import '../../theme/texts/custom_texts.dart';
import '../global/custom_appbar.dart';
import '../global/methods/custom_show_dialog.dart';
import 'bottom_sheet.dart';

class RegisterFillInformScreen extends StatefulWidget {
  const RegisterFillInformScreen({super.key});

  @override
  State<RegisterFillInformScreen> createState() =>
      _RegisterFillInformScreenState();
}

class _RegisterFillInformScreenState extends State<RegisterFillInformScreen> {
  final RegisterOrganizationController _registerController =
      RegisterOrganizationController();
  final RegisterNameController _registerNameController =
      RegisterNameController();

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
                context,
                context.tr('email_sent'),
                context.tr('email_sent_message'),
              );
            } else if (state is EmailError) {
              _isEmailButtonEnabled = true;
              customShowDialog(
                context,
                context.tr('email_sent_error'),
                context.tr('email_sent_error_message'),
              );
            }
          },
        ),
        BlocListener<RegisterNicknameController, NicknameState>(
          listener: (context, state) {
            if (state is NicknameChecked) {
              customShowDialog(
                context,
                context.tr('nickname_checked'),
                context.tr('nickname_checked_message'),
              );
            } else if (state is NicknameAlreadyTaken) {
              _isNicknameButtonEnabled = true;
              customShowDialog(
                context,
                context.tr('nickname_unchecked'),
                context.tr('nickname_unchecked_message'),
              );
            } else if (state is NicknameError) {
              _isNicknameButtonEnabled = true;
              customShowDialog(
                context,
                context.tr('nickname_check_error'),
                context.tr('nickname_check_error_message'),
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
          appBar: CustomAppBar(
            title: Text(
              context.tr('register_fill_inform'),
              style: CustomTexts.displaySmall,
            ),
            iconTheme: IconThemeData(
              color: context.appColors.primary,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text(organization,
                            style: CustomTexts.labelLarge.copyWith(
                                color: context.appColors.onBackground)),
                        const SizedBox(width: 15),
                        Text(
                            department != ''
                                ? context
                                    .tr('register_college_of', args: [college])
                                : college,
                            style: CustomTexts.labelLarge.copyWith(
                                color: context.appColors.onBackground)),
                        const SizedBox(width: 15),
                        Text(department,
                            style: CustomTexts.labelLarge.copyWith(
                                color: context.appColors.onBackground)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    context.tr('register_name'),
                    style: CustomTexts.subtitleLarge.copyWith(
                      color: context.appColors.onBackground,
                    ),
                  ),
                  TextField(
                    controller: _registerNameController.nameController,
                    maxLength: 6,
                    cursorColor: context.appColors.primary,
                    onChanged: (value) {
                      if (!RegExp(r'[ㅏ-ㅣㄱ-ㅎ]').hasMatch(value)) {
                        _isNameValid = true;
                      } else {
                        _isNameValid = false;
                      }
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Zㄱ-ㅎ가-힣]'))
                    ],
                    style: CustomTexts.bodyLarge.copyWith(
                      color: context.appColors.onBackground,
                    ),
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: context.tr("register_name_hint"),
                      hintStyle: CustomTexts.bodyLarge.copyWith(
                        color: context.appColors.onBackground.withOpacity(0.3),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color:
                              context.appColors.onBackground.withOpacity(0.2),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: context.appColors.primary,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    context.tr('student_id'),
                    style: CustomTexts.subtitleLarge.copyWith(
                      color: context.appColors.onBackground,
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: TextField(
                          controller: registerSidController.sidController,
                          keyboardType: TextInputType.number,
                          maxLength: 8,
                          cursorColor: context.appColors.primary,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          onChanged: (value) {
                            registerSidController.add(EmailChanged());
                            if (value.length >= 8) {
                              _isEmailButtonEnabled = true;
                            } else {
                              _isEmailButtonEnabled = false;
                            }
                            setState(() {});
                          },
                          style: CustomTexts.bodyLarge.copyWith(
                            color: context.appColors.onBackground,
                          ),
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: context.tr("register_sid_hint"),
                            hintStyle: CustomTexts.bodyLarge.copyWith(
                              color: context.appColors.onBackground
                                  .withOpacity(0.3),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: context.appColors.onBackground
                                    .withOpacity(0.2),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: context.appColors.primary,
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      BlocBuilder<RegisterSidController, EmailState>(
                        builder: (context, state) => Flexible(
                          child: GestureDetector(
                            onTap: _isEmailButtonEnabled
                                ? () {
                                    _isEmailButtonEnabled = false;
                                    registerSidController.add(EmailRequest());
                                  }
                                : () {},
                            child: CustomRoundedBorderedContainer(
                              color: _isEmailButtonEnabled
                                  ? context.appColors.primary
                                  : context.appColors.onBackground
                                      .withOpacity(0.3),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 16.0),
                                child: Center(
                                  child: AutoSizeText(
                                    maxLines: 1,
                                    context.tr('validate_mail'),
                                    style: CustomTexts.subtitleLarge.copyWith(
                                      color: context.appColors.onPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    context.tr('nickname'),
                    style: CustomTexts.subtitleLarge.copyWith(
                      color: context.appColors.onBackground,
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: TextField(
                          controller:
                              registerNicknameController.nicknameController,
                          onChanged: (value) {
                            registerNicknameController.add(NicknameChanged());
                            if (value.length >= 2) {
                              _isNicknameButtonEnabled = true;
                            } else {
                              _isNicknameButtonEnabled = false;
                            }
                            setState(() {});
                          },
                          maxLength: 10,
                          cursorColor: context.appColors.primary,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z0-9ㄱ-ㅎ가-힣]'))
                          ],
                          style: CustomTexts.bodyLarge.copyWith(
                            color: context.appColors.onBackground,
                          ),
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: context.tr("register_nickname_hint"),
                            hintStyle: CustomTexts.bodyLarge.copyWith(
                              color: context.appColors.onBackground
                                  .withOpacity(0.3),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: context.appColors.onBackground
                                    .withOpacity(0.2),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: context.appColors.primary,
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      BlocBuilder<RegisterNicknameController, NicknameState>(
                        builder: (context, state) => Flexible(
                          child: GestureDetector(
                            onTap: _isNicknameButtonEnabled
                                ? () async {
                                    final String text =
                                        registerNicknameController
                                            .nicknameController.text;
                                    // 닉네임에 초성이 포함된 경우
                                    if (RegExp(r'[ㅏ-ㅣㄱ-ㅎ]').hasMatch(text)) {
                                      customShowDialog(
                                          context,
                                          context.tr('inapropriate_nickname'),
                                          context.tr(
                                              'nickname_has_initial_consonant'));
                                    }
                                    // 닉네임에 비속어가 포함된 경우
                                    else if (customProfanityFilter
                                        .hasMatch(text)) {
                                      customShowDialog(
                                          context,
                                          context.tr('inapropriate_nickname'),
                                          context.tr(
                                              'inapropriate_nickname_message'));
                                    } else {
                                      _isNicknameButtonEnabled = false;
                                      registerNicknameController
                                          .add(NicknameRequest());
                                    }
                                  }
                                : () {},
                            child: CustomRoundedBorderedContainer(
                              color: _isNicknameButtonEnabled
                                  ? context.appColors.primary
                                  : context.appColors.onBackground
                                      .withOpacity(0.3),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 16.0),
                                child: Center(
                                  child: AutoSizeText(
                                    maxLines: 1,
                                    context.tr('validate_nickname'),
                                    style: CustomTexts.subtitleLarge.copyWith(
                                      color: context.appColors.onPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    context.tr('why_do_i_need_to_sign'),
                    style: CustomTexts.subtitleLarge.copyWith(
                      color: context.appColors.onBackground,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    context.tr('wdints_content'),
                    style: CustomTexts.bodyLarge.copyWith(
                      color: context.appColors.onBackground,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => NavigatorKeyManager()
                        .pushNamed(RouteNames.registerSign),
                    child: CustomRoundedBorderedContainer(
                      color: context.appColors.primary,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            context.tr('sign'),
                            style: CustomTexts.subtitleLarge
                                .copyWith(color: context.appColors.onPrimary),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomRoundedBorderedContainer(
                    width: context.width,
                    height: 200,
                    borderWidth: 0.5,
                    color: context.appColors.background,
                    child: FutureBuilder(
                      future: _registerSignProvider.signToImage(),
                      builder: (context, snapshot) => snapshot.hasData
                          ? Image.memory(snapshot.data!)
                          : Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: AutoSizeText(
                                  maxLines: 1,
                                  context.tr('sign_content'),
                                  style: CustomTexts.bodyLarge.copyWith(
                                    color: context.appColors.onBackground,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) =>
                                  StatefulBottomSheet(
                                    setIsAgreementChecked:
                                        setIsAgreementChecked,
                                  ));
                        },
                        child: Text(
                          context.tr('terms_of_agreement'),
                          style: CustomTexts.subtitleLarge
                              .copyWith(color: context.appColors.onBackground),
                        ),
                      ),
                      Checkbox(
                        value: _registerAgreementProvider.isAgreementChecked,
                        activeColor: context.appColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onChanged: (value) {
                          setIsAgreementChecked(value!);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BlocBuilder<RegisterSidController, EmailState>(
            builder: (context, sidState) =>
                BlocBuilder<RegisterNicknameController, NicknameState>(
              builder: (context, nicknameState) => GestureDetector(
                onTap: () {
                  if (_isNameValid &&
                      sidState is EmailSent &&
                      nicknameState is NicknameChecked &&
                      _registerAgreementProvider.isAgreementChecked) {
                    log('Sign Up Button Pressed');
                  } else {
                    return;
                  }
                },
                child: BottomAppBar(
                  height: context.width * 0.12,
                  color: getBottomAppBarColor(context, sidState, nicknameState),
                  child: Center(
                    child: Text(
                      maxLines: 1,
                      context.tr('sign_up'),
                      style: CustomTexts.titleLarge.copyWith(
                        color: context.appColors.onPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color getBottomAppBarColor(
      BuildContext context, EmailState sidState, NicknameState nicknameState) {
    if (_isNameValid &&
        sidState is EmailSent &&
        nicknameState is NicknameChecked &&
        _registerAgreementProvider.isAgreementChecked) {
      return context.appColors.primary;
    } else {
      return context.appColors.onBackground.withOpacity(0.3);
    }
  }

  void setIsAgreementChecked(bool value) {
    setState(() {
      _registerAgreementProvider.isAgreementChecked = value;
    });
  }

  String get organization => _registerController.organization;

  String get college => _registerController.registerCollegeProvider.college;

  String get department => _registerController
      .registerCollegeProvider.registerDepartmentProvider.department;

  RegisterSignController get _registerSignProvider =>
      _registerController.registerSignProvider;

  RegisterAgreementController get _registerAgreementProvider =>
      _registerSignProvider.registerAgreementProvider;

  bool _isNameValid = false;
  bool _isEmailButtonEnabled = false;
  bool _isNicknameButtonEnabled = false;
}
