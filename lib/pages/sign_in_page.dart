import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:BEAT/theme/texts/custom_texts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../business/user_bloc.dart';
import '../widgets/global/custom_scaffold.dart';
import '../widgets/global/rounded_bordered_container.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController _studentIdController =
      TextEditingController(text: '20191137');
  final TextEditingController _nicknameController =
      TextEditingController(text: '김현겸');
  final UserBloc _userBloc = UserBloc();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
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
                style: CustomTexts.titleLarge,
              ),
              TextField(
                controller: _studentIdController,
                decoration: InputDecoration(
                  hintText: context.tr("sid_hint"),
                  hintStyle: CustomTexts.bodyLarge,
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
                style: CustomTexts.titleLarge,
              ),
              TextField(
                controller: _nicknameController,
                decoration: InputDecoration(
                  hintText: context.tr("nickname_hint"),
                  hintStyle: CustomTexts.bodyLarge,
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
                child: RoundedBorderedContainer(
                  color: context.appColors.primary,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        context.tr('sign_in'),
                        style: CustomTexts.titleLarge
                            .copyWith(color: context.appColors.onPrimary),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {},
                child: RoundedBorderedContainer(
                  color: context.appColors.secondary,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        context.tr('register'),
                        style: CustomTexts.titleLarge,
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
                    padding: EdgeInsets.symmetric(horizontal: 16),
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
    );
  }

  SignInPage({super.key});
}
