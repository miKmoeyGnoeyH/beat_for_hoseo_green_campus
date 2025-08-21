import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../managers/navigator/navigator_key_manager.dart';
import '../../../managers/navigator/routes.dart';
import '../../global/widgets/buttons/custom_wide_button.dart';

class SignInRegisterButton extends StatelessWidget {
  const SignInRegisterButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomWideButton(
      onTap: () =>
          NavigatorKeyManager().pushNamed(RouteNames.registerOrganization),
      buttonColor: context.appColors.background,
      buttonText: context.tr('register'),
      textColor: context.appColors.onBackground,
      borderWidth: 0.5,
    );
  }
}