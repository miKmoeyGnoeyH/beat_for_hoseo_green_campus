import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../controller/user_bloc.dart';
import '../../../data/models/user_model.dart';
import '../../global/widgets/buttons/custom_wide_button.dart';

class SignInSignInButton extends StatelessWidget {
  const SignInSignInButton({
    super.key,
    required TextEditingController studentIdController,
    required TextEditingController nicknameController,
  })  : _studentIdController = studentIdController,
        _nicknameController = nicknameController;

  final TextEditingController _studentIdController;
  final TextEditingController _nicknameController;

  @override
  Widget build(BuildContext context) {
    final UserBloc userBloc = context.read<UserBloc>();

    return BlocBuilder<UserBloc, User>(
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
    );
  }
}