import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../controller/user_controller.dart';
import '../../../data/models/user_model.dart';
import '../../global/widgets/buttons/custom_wide_button.dart';

class SignInSignInButton extends StatelessWidget {
  SignInSignInButton({
    super.key,
    required TextEditingController studentIdController,
    required TextEditingController nicknameController,
  })  : _studentIdController = studentIdController,
        _nicknameController = nicknameController;

  final TextEditingController _studentIdController;
  final TextEditingController _nicknameController;

  final LocalizationManager localizationManager = LocalizationManager();

  @override
  Widget build(BuildContext context) {
    final UserController userBloc = context.read<UserController>();

    return BlocBuilder<UserController, User>(
      builder: (context, state) => CustomWideButton(
        onTap: state is IsLoading
            ? () {}
            : () {
          FocusScope.of(context).unfocus();
          userBloc.add(
            SignIn(
              _studentIdController.text,
              _nicknameController.text,
            ),
          );
        },
        buttonColor: state is IsLoading
            ? context.appColors.disabled
            : context.appColors.primary,
        buttonText: localizationManager.signInSignIn,
      ),
    );
  }
}