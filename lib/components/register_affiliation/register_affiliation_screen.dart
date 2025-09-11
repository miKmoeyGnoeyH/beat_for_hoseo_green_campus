import 'package:beat_flutter/components/global/methods/custom_show_dialog.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:beat_flutter/managers/navigator/arguments/register_arguments.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../controller/register/register_college_controller.dart';
import '../../controller/register/register_department_controller.dart';
import '../../controller/register/register_organization_controller.dart';
import '../../managers/navigator/navigator_key_manager.dart';
import '../../managers/navigator/routes.dart';
import '../global/widgets/buttons/custom_bottom_appbar_button.dart';
import '../global/widgets/custom_scaffold.dart';
import '../global/widgets/custom_text_field.dart';
import '../register_organization/widgets/register_organization_appbar.dart';

class RegisterAffiliationScreen extends StatefulWidget {
  RegisterAffiliationScreen(
    this.registerArguments, {
    super.key,
  });

  final RegisterArguments registerArguments;
  final RegisterDepartmentController registerDepartmentController =
      RegisterDepartmentController.fromAffiliation();

  @override
  State<RegisterAffiliationScreen> createState() =>
      _RegisterAffiliationScreenState();
}

class _RegisterAffiliationScreenState extends State<RegisterAffiliationScreen> {
  final LocalizationManager localizationManager = LocalizationManager();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: CustomScaffold(
        top: false,
        isScrollable: false,
        appBar: RegisterBasicAppbar(
          text: context.tr('affiliation'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: CustomTextField(
              maxLength: 10,
              hintText: context.tr('affiliation_hint'),
              onChanged: (value) {
                registerDepartmentController.department = value;
                isLengthValid = value.length >= minLength;
                setState(() {});
              },
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomAppbarButton(
          onTap: isLengthValid
              ? () {
                  if (RegExp(r'[ㅏ-ㅣㄱ-ㅎ]').hasMatch(registerDepartmentController.department)) {
                    customShowDialog(
                      context: context,
                      title: localizationManager.raInappropriateAffiliationTitle,
                      content:
                          localizationManager.raInappropriateAffiliationContent,
                    );
                  } else {
                    NavigatorKeyManager().pushNamed(
                      RouteNames.registerFillInform,
                      arguments: RegisterArguments(
                        registerOrganizationController:
                            registerOrganizationController,
                        registerCollegeController: registerCollegeController,
                        registerDepartmentController:
                            registerDepartmentController,
                      ),
                    );
                  }

                }
              : () {},
          text: localizationManager
              .rcContinueWith(registerDepartmentController.department),
          backgroundColor: isLengthValid
              ? context.appColors.primary
              : context.appColors.disabled,
        ),
      ),
    );
  }

  RegisterOrganizationController? get registerOrganizationController =>
      widget.registerArguments.registerOrganizationController;

  RegisterCollegeController? get registerCollegeController =>
      widget.registerArguments.registerCollegeController;

  RegisterDepartmentController get registerDepartmentController =>
      widget.registerDepartmentController;

  final int minLength = 3;
  bool isLengthValid = false;
}
