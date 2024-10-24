import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:BEAT/widgets/global/methods/custom_show_dialog.dart';
import 'package:BEAT/widgets/sign_in/sign_in_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controller/user_bloc.dart';
import '../../data/models/user_model.dart';
import '../../managers/navigator/navigator_key_manager.dart';
import '../../managers/navigator/routes.dart';
import '../../managers/prefs/prefs_manager.dart';
import '../global/custom_label_large.dart';
import '../global/beat/beat_full_logo.dart';
import '../global/custom_scaffold.dart';
import '../global/custom_vertical_divider.dart';
import '../global/custom_wide_button.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController _studentIdController = TextEditingController(
      text: PrefsManager.getValueAs<String>('saved_studentId'));
  final TextEditingController _nicknameController = TextEditingController(
      text: PrefsManager.getValueAs<String>('saved_nickname'));

  @override
  Widget build(BuildContext context) {
    final UserBloc userBloc = context.read<UserBloc>();

    return BlocListener<UserBloc, User>(
      listener: (context, state) {
        if (state.isError) {
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
                  SignInTextField(
                    title: context.tr('student_id'),
                    hintText: context.tr("sid_hint"),
                    textEditingController: _studentIdController,
                    keyboardType: TextInputType.number,
                    maxLength: 8,
                  ),
                  const SizedBox(height: 24),
                  SignInTextField(
                    title: context.tr('nickname'),
                    hintText: context.tr("nickname_hint"),
                    textEditingController: _nicknameController,
                    maxLength: 10,
                  ),
                  const SizedBox(height: 36),
                  BlocBuilder<UserBloc, User>(
                    builder: (context, state) => CustomWideButton(
                      onTap: state.isLoading
                          ? () {}
                          : () => userBloc.add(
                                SignIn(
                                  _studentIdController.text,
                                  _nicknameController.text,
                                ),
                              ),
                      buttonColor: state.isLoading
                          ? context.appColors.disabled
                          : context.appColors.primary,
                      buttonText: context.tr('sign_in'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  CustomWideButton(
                    onTap: () => NavigatorKeyManager()
                        .pushNamed(RouteNames.registerOrganization),
                    buttonColor: context.appColors.background,
                    buttonText: context.tr('register'),
                    textColor: context.appColors.onBackground,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: CustomLabelLarge(
                          labelText: context.tr('forgot_sid'),
                        ),
                      ),
                      const CustomVerticalDivider(height: 12.5),
                      GestureDetector(
                        onTap: () {},
                        child: CustomLabelLarge(
                          labelText: context.tr('forgot_nickname'),
                        ),
                      ),
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