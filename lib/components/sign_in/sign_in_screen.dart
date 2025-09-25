import 'package:beat_flutter/components/global/widgets/custom_circular_progress_indicator.dart';
import 'package:beat_flutter/components/global/widgets/custom_text_field.dart';
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

class SignInScreen extends StatefulWidget {
  @override
  State<SignInScreen> createState() => _SignInScreenState();

  const SignInScreen({super.key});
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController =
      TextEditingController(text: PrefsManager().getSavedStudentId());

  final TextEditingController passwordController =
      TextEditingController(text: PrefsManager().getSavedPassword());

  final FocusNode emailFocusNode = FocusNode();

  final FocusNode passwordFocusNode = FocusNode();

  final LocalizationManager localizationManager = LocalizationManager();

  @override
  void initState() {
    for (final node in [
      emailFocusNode,
      passwordFocusNode,
    ]) {
      node.addListener(_onAnyFocusChange);
    }

    emailController.addListener(() => setState(() {}));
    passwordController.addListener(() => setState(() {}));

    super.initState();
  }

  @override
  void dispose() {
    for (final node in [
      emailFocusNode,
      passwordFocusNode,
    ]) {
      node.addListener(_onAnyFocusChange);
      node.dispose();
    }

    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  void _onAnyFocusChange() => setState(() {});

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
          top: false,
          isScrollable: false,
          hasScrollBody: false,
          backgroundColor: context.appColors.background,
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    const BeatFullLogo(),
                    CustomTextField(
                      textEditingController: emailController,
                      focusNode: emailFocusNode,
                      labelText: localizationManager.signInSidOrId,
                      hintText: localizationManager.signInSidOrIdHint,
                      maxLines: emailFocusNode.hasFocus ? 2 : 1,
                    ),
                    // SignInSIDField(studentIdController: emailController),
                    SizedBox(height: 24.w),
                    CustomTextField(
                      textEditingController: passwordController,
                      focusNode: passwordFocusNode,
                      labelText: localizationManager.signInPassword,
                      hintText: localizationManager.signInPasswordHint,
                      obscureText: true,
                    ),
                    // SignInPasswordField(nicknameController: passwordController),
                    SizedBox(height: 36.w),
                    SignInSignInButton(
                      studentIdController: emailController,
                      nicknameController: passwordController,
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
      ),
    );
  }

  void onForgotPasswordTap() {
    // log("forgot password");
    NavigatorKeyManager().pushNamed(RouteNames.resetPassword);
  }
}
