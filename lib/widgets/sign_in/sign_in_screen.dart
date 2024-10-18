import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../business/user_bloc.dart';
import '../../managers/navigator/navigator_key_manager.dart';
import '../../managers/navigator/routes.dart';
import '../../managers/prefs/prefs_manager.dart';
import '../../theme/texts/custom_texts.dart';
import '../global/custom_scaffold.dart';
import '../global/custom_rounded_bordered_container.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController _studentIdController = TextEditingController(
      text: PrefsManager.getValueAs<String>('saved_studentId'));
  final TextEditingController _nicknameController = TextEditingController(
      text: PrefsManager.getValueAs<String>('saved_nickname'));

  final UserBloc _userBloc = UserBloc();
  final NavigatorKeyManager _navigatorKeyManager = NavigatorKeyManager();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      onTapDown: (_) => FocusScope.of(context).unfocus(),
      child: CustomScaffold(
        isScrollable: false,
        top: true,
        backgroundColor: context.appColors.background,
        hasScrollBody: false,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    child: Image.asset(
                      'assets/images/beat_full_logo.png',
                      width: context.width * 0.3,
                    ),
                  ),
                ),
                Text(
                  context.tr('student_id'),
                  style: CustomTexts.titleLarge.copyWith(
                    color: context.appColors.onBackground,
                  ),
                ),
                TextField(
                  controller: _studentIdController,
                  keyboardType: TextInputType.number,
                  maxLength: 8,
                  cursorColor: context.appColors.primary,
                  style: CustomTexts.bodyLarge.copyWith(
                    color: context.appColors.onBackground,
                  ),
                  decoration: InputDecoration(
                    hintText: context.tr("sid_hint"),
                    hintStyle: CustomTexts.bodyLarge.copyWith(
                      color: context.appColors.onBackground.withOpacity(0.5),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: context.appColors.onBackground.withOpacity(0.2),
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: context.appColors.primary,
                        width: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  context.tr('nickname'),
                  style: CustomTexts.titleLarge.copyWith(
                    color: context.appColors.onBackground,
                  ),
                ),
                TextField(
                  controller: _nicknameController,
                  maxLength: 10,
                  cursorColor: context.appColors.primary,
                  style: CustomTexts.bodyLarge.copyWith(
                    color: context.appColors.onBackground,
                  ),
                  decoration: InputDecoration(
                    hintText: context.tr("nickname_hint"),
                    hintStyle: CustomTexts.bodyLarge.copyWith(
                      color: context.appColors.onBackground.withOpacity(0.5),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: context.appColors.onBackground.withOpacity(0.2),
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: context.appColors.primary,
                        width: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                GestureDetector(
                  onTap: () => _userBloc.add(
                    SignIn(
                      _studentIdController.text,
                      _nicknameController.text,
                    ),
                  ),
                  child: CustomRoundedBorderedContainer(
                    color: context.appColors.primary,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          context.tr('sign_in'),
                          style: CustomTexts.subtitleLarge
                              .copyWith(color: context.appColors.onPrimary),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => _navigatorKeyManager.pushNamed(RouteNames.registerOrganization),
                  child: CustomRoundedBorderedContainer(
                    color: context.appColors.background,
                    borderColor: context.appColors.onBackground,
                    borderWidth: 0.5,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          context.tr('register'),
                          style: CustomTexts.subtitleLarge.copyWith(
                            color: context.appColors.onBackground,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        context.tr('forgot_sid'),
                        style: CustomTexts.labelLarge.copyWith(
                          color:
                              context.appColors.onBackground.withOpacity(0.5),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        width: 1,
                        height: 12.5,
                        color: context.appColors.onBackground.withOpacity(0.5),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        context.tr('forgot_nickname'),
                        style: CustomTexts.labelLarge.copyWith(
                          color:
                              context.appColors.onBackground.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  SignInScreen({super.key});
}
