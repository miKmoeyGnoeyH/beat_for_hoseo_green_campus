import 'package:beat_flutter/business/user_bloc.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/widgets/global/rounded_bordered_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../widgets/global/custom_scaffold.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController _studentIdController =
      TextEditingController(text: '20191137');
  final TextEditingController _nicknameController =
      TextEditingController(text: '김현겸');
  final UserBloc _userBloc = UserBloc();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      top: true,
      backgroundColor: context.colorScheme.secondary,
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
                style: context.textTheme.titleLarge,
              ),
              TextField(
                controller: _studentIdController,
                decoration: InputDecoration(
                  hintText: context.tr("sid_hint"),
                  hintStyle: context.textTheme.bodyLarge!.copyWith(
                    color: context.colorScheme.onSurface.withOpacity(0.2),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: context.colorScheme.onSurface.withOpacity(0.2),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: context.colorScheme.primary, width: 1),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                context.tr('nickname'),
                style: context.textTheme.titleLarge,
              ),
              TextField(
                controller: _nicknameController,
                decoration: InputDecoration(
                  hintText: context.tr("nickname_hint"),
                  hintStyle: context.textTheme.bodyLarge!.copyWith(
                    color: context.colorScheme.onSurface.withOpacity(0.2),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: context.colorScheme.onSurface.withOpacity(0.2),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: context.colorScheme.primary, width: 1),
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
                  color: context.colorScheme.primary,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        context.tr('sign_in'),
                        style: context.textTheme.titleLarge!
                            .copyWith(color: context.colorScheme.onPrimary),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {},
                child: RoundedBorderedContainer(
                  color: context.colorScheme.secondary,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        context.tr('register'),
                          style: context.textTheme.titleLarge,
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
                      style: context.textTheme.labelLarge,
                    ),
                  ),
                  const SizedBox(width: 32),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      context.tr('forgot_nickname'),
                      style: context.textTheme.labelLarge,
                    ),
                  )
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
