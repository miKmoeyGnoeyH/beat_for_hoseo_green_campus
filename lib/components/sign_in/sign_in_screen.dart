import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controller/user_bloc.dart';
import '../../data/models/user_model.dart';
import '../../managers/prefs/prefs_manager.dart';
import '../global/beat/beat_full_logo.dart';
import '../global/widgets/custom_scaffold.dart';
import '../global/widgets/custom_vertical_divider.dart';
import '../global/methods/custom_show_dialog.dart';
import 'methods/build_forgot_button.dart';
import 'widgets/sign_in_nickname_field.dart';
import 'widgets/sign_in_register_button.dart';
import 'widgets/sign_in_sid_field.dart';
import 'widgets/sign_in_sign_in_button.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController _studentIdController = TextEditingController(
      text: PrefsManager.getValueAs<String>('saved_studentId'));
  final TextEditingController _nicknameController = TextEditingController(
      text: PrefsManager.getValueAs<String>('saved_nickname'));

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, User>(
      listener: (context, state) {
        if (state is ErrorUser) {
          customShowDialog(
            context,
            context.tr('sign_in_failed'),
            state.studentId,
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
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const BeatFullLogo(),
                  SignInSIDField(studentIdController: _studentIdController),
                  const SizedBox(height: 24),
                  SignInNicknameField(nicknameController: _nicknameController),
                  const SizedBox(height: 36),
                  SignInSignInButton(
                    studentIdController: _studentIdController,
                    nicknameController: _nicknameController,
                  ),
                  const SizedBox(height: 12),
                  const SignInRegisterButton(),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildSignInForgotSIDButton(context),
                      const CustomVerticalDivider(height: 12.5),
                      buildSignInForgotNicknameButton(context),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SignInScreen({super.key});
}
