import 'package:beat_flutter/components/register_fill_inform/widgets/rfi_regexp.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:beat_flutter/managers/navigator/arguments/register_arguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  final FocusNode affiliationFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    affiliationFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    affiliationFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: CustomScaffold(
        // top: false,
        // isScrollable: false,
        // hasScrollBody: false,
        appBar: RegisterBasicAppbar(
          text: localizationManager.raAppbarTitle,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                // maxLength: 10,
                ensureErrorTextSpace: true,
                focusNode: affiliationFocusNode,
                maxLines: affiliationFocusNode.hasFocus
                    ? 2
                    : 1,
                hintText: localizationManager.raAffiliationHint,
                onChanged: (value) {
                  registerDepartmentController.department = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    _isAffiliationValid = false;
                    return localizationManager.raAffiliationHint;
                  } else if (value.length < minLength) {
                    _isAffiliationValid = false;
                    return localizationManager.raAffiliationHint;
                  } else if (initialConsonantRegExp.hasMatch(value)) {
                    _isAffiliationValid = false;
                    return localizationManager
                        .raInappropriateAffiliationContent;
                  }
                  _isAffiliationValid = true;
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              SizedBox(height: 35.w),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomAppbarButton(
          onTap: _isAffiliationValid
              ? () {
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
              : () {},
          text: localizationManager
              .rcContinueWith(registerDepartmentController.department),
          backgroundColor: _isAffiliationValid
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

  final int minLength = 1;
  bool _isAffiliationValid = false;
}
