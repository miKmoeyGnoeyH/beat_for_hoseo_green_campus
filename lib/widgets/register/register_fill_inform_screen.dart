
import 'package:BEAT/data/provider/register/register_agreement_provider.dart';
import 'package:BEAT/data/provider/register/register_organization_provider.dart';
import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:BEAT/managers/navigator/navigator_key_manager.dart';
import 'package:BEAT/managers/navigator/routes.dart';
import 'package:BEAT/widgets/global/custom_rounded_bordered_container.dart';
import 'package:BEAT/widgets/global/custom_scaffold.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../data/provider/register/register_sign_provider.dart';
import '../../theme/texts/custom_texts.dart';
import '../global/custom_appbar.dart';
import 'bottom_sheet.dart';

class RegisterFillInformScreen extends StatefulWidget {
  const RegisterFillInformScreen({super.key});

  @override
  State<RegisterFillInformScreen> createState() =>
      _RegisterFillInformScreenState();
}

class _RegisterFillInformScreenState extends State<RegisterFillInformScreen> {
  final RegisterOrganizationProvider _registerController =
      RegisterOrganizationProvider();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                      Text(organization, style: CustomTexts.labelLarge),
                      const SizedBox(width: 15),
                      Text(
                          department != ''
                              ? context
                                  .tr('register_college_of', args: [college])
                              : college,
                          style: CustomTexts.labelLarge),
                      const SizedBox(width: 15),
                      Text(department, style: CustomTexts.labelLarge),
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
                  // controller: _studentIdController,
                  keyboardType: TextInputType.number,
                  maxLength: 8,
                  cursorColor: context.appColors.primary,
                  style: CustomTexts.bodyLarge.copyWith(
                    color: context.appColors.onBackground,
                  ),
                  decoration: InputDecoration(
                    counterText: "",
                    hintText: context.tr("register_name_hint"),
                    hintStyle: CustomTexts.bodyLarge.copyWith(
                      color: context.appColors.onBackground.withOpacity(0.5),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: context.appColors.onBackground.withOpacity(0.2),
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
                        // controller: _studentIdController,
                        keyboardType: TextInputType.number,
                        maxLength: 8,
                        cursorColor: context.appColors.primary,
                        style: CustomTexts.bodyLarge.copyWith(
                          color: context.appColors.onBackground,
                        ),
                        decoration: InputDecoration(
                          counterText: "",
                          hintText: context.tr("register_sid_hint"),
                          hintStyle: CustomTexts.bodyLarge.copyWith(
                            color:
                                context.appColors.onBackground.withOpacity(0.5),
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
                    Flexible(
                      child: GestureDetector(
                        child: CustomRoundedBorderedContainer(
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
                        // controller: _studentIdController,
                        keyboardType: TextInputType.number,
                        maxLength: 8,
                        cursorColor: context.appColors.primary,
                        style: CustomTexts.bodyLarge.copyWith(
                          color: context.appColors.onBackground,
                        ),
                        decoration: InputDecoration(
                          counterText: "",
                          hintText: context.tr("register_nickname_hint"),
                          hintStyle: CustomTexts.bodyLarge.copyWith(
                            color:
                                context.appColors.onBackground.withOpacity(0.5),
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
                    Flexible(
                      child: CustomRoundedBorderedContainer(
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
                  onTap: () =>
                      NavigatorKeyManager().pushNamed(RouteNames.registerSign),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
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
                                  setIsAgreementChecked: setIsAgreementChecked,
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
              ],
            ),
          ),
        ),
        bottomNavigationBar: GestureDetector(
          onTap: () {},
          child: BottomAppBar(
            height: context.width * 0.12,
            color: context.appColors.primary,
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
    );
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

  RegisterSignProvider get _registerSignProvider => _registerController.registerSignProvider;

  RegisterAgreementProvider get _registerAgreementProvider => _registerSignProvider.registerAgreementProvider;
}
