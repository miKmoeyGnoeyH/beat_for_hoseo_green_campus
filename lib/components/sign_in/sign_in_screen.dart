import 'package:beat_flutter/components/global/widgets/custom_circular_progress_indicator.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_body_large.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:beat_flutter/managers/navigator/navigator_key_manager.dart';
import 'package:beat_flutter/managers/navigator/routes.dart';
import 'package:beat_flutter/managers/prefs/prefs_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/user_controller.dart';
import '../../data/models/user_model.dart';
import '../global/beat/beat_full_logo.dart';
import '../global/widgets/custom_scaffold.dart';
import '../global/methods/custom_show_dialog.dart';
import 'widgets/sign_in_nickname_field.dart';
import 'widgets/sign_in_register_button.dart';
import 'widgets/sign_in_sid_field.dart';
import 'widgets/sign_in_sign_in_button.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController _studentIdController =
      TextEditingController(text: PrefsManager().getSavedStudentId());
  final TextEditingController _nicknameController =
      TextEditingController(text: PrefsManager().getSavedPassword());

  final LocalizationManager localizationManager = LocalizationManager();

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserController, User>(
      // listenWhen: (prev, curr) => prev is! ErrorUser && curr is ErrorUser,
      listener: (context, state) {
        // log("SignInScreen: BlocListener: ${state.studentId}");
        if (Get.isDialogOpen == true) Get.back();

        if (state is ErrorUser) {
          customShowDialog(
            context: context,
            title: localizationManager.signInSignInFailed,
            content: state.studentId,
          );
        }
        if (state is IsLoading) {
          Get.dialog(
            const CustomCircularProgressIndicator(),
          );
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        onTapDown: (_) => FocusScope.of(context).unfocus(),
        child: CustomScaffold(
          top: true,
          isScrollable: false,
          hasScrollBody: false,
          backgroundColor: context.appColors.background,
          body: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  const BeatFullLogo(),
                  SignInSIDField(studentIdController: _studentIdController),
                  SizedBox(height: 24.w),
                  SignInPasswordField(nicknameController: _nicknameController),
                  SizedBox(height: 36.w),
                  SignInSignInButton(
                    studentIdController: _studentIdController,
                    nicknameController: _nicknameController,
                  ),
                  SizedBox(height: 12.w),
                  SignInRegisterButton(),
                  SizedBox(height: 24.w),
                  GestureDetector(
                    onTap: onForgotPasswordTap,
                    child: CustomBodyLarge(
                      text: localizationManager.signInForgotPassword,
                      // textColor: context.appColors.disabled,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onForgotPasswordTap() {
    // log("forgot password");
    NavigatorKeyManager().pushNamed(RouteNames.resetPassword);
  }

  SignInScreen({super.key});
}
