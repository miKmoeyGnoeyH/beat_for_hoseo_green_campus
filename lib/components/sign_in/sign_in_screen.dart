import 'dart:developer';

import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controller/user_controller.dart';
import '../../data/models/user_model.dart';
import '../../managers/prefs/prefs_manager.dart';
import '../global/beat/beat_full_logo.dart';
import '../global/widgets/custom_scaffold.dart';
import '../global/methods/custom_show_dialog.dart';
import 'widgets/sign_in_nickname_field.dart';
import 'widgets/sign_in_register_button.dart';
import 'widgets/sign_in_sid_field.dart';
import 'widgets/sign_in_sign_in_button.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController _studentIdController = TextEditingController(
      text: PrefsManager().getValueAs<String>('saved_studentId'));
  final TextEditingController _nicknameController = TextEditingController(
      text: PrefsManager().getValueAs<String>('saved_nickname'));

  final LocalizationManager localizationManager = LocalizationManager();

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserController, User>(
      // listenWhen: (prev, curr) => prev is! ErrorUser && curr is ErrorUser,
      listener: (context, state) {
        log("SignInScreen: BlocListener: $state");
        if (state is ErrorUser) {
          customShowDialog(
            context: context,
            title: localizationManager.signInSignInFailed,
            content: state.studentId,
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
                  SignInRegisterButton(),
                  const SizedBox(height: 24),
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
