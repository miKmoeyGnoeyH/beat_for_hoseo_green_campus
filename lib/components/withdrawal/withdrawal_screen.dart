import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../controller/user_controller.dart';
import '../../managers/navigator/navigator_key_manager.dart';
import '../../managers/navigator/routes.dart';
import '../../managers/prefs/prefs_manager.dart';
import '../global/methods/custom_show_dialog.dart';
import '../global/widgets/appbars/custom_empty_appbar.dart';
import '../global/widgets/buttons/custom_wide_button.dart';
import '../global/widgets/custom_scaffold.dart';
import '../global/widgets/texts/custom_body_large.dart';
import '../global/widgets/texts/custom_headline_medium.dart';
import '../global/widgets/texts/custom_title_large.dart';

class WithdrawalScreen extends StatelessWidget {
  const WithdrawalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = context.read<UserController>();

    return CustomScaffold(
      isScrollable: false,
      hasScrollBody: false,
      appBar: const CustomEmptyAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomHeadlineMedium(text: context.tr('withdrawal')),
            const SizedBox(height: 24),
            CustomTitleLarge(text: context.tr('notes')),
            const SizedBox(height: 16),
            CustomBodyLarge(
                text: '1. ${context.tr('withdrawal_notes', gender: '1')}'),
            // const SizedBox(height: 10),
            // CustomBodyLarge(text: context.tr('withdrawal_notes', gender: '2')),
            const SizedBox(height: 10),
            CustomBodyLarge(
                text: '2. ${context.tr('withdrawal_notes', gender: '3')}'),
            const SizedBox(height: 10),
            CustomBodyLarge(
                text: '3. ${context.tr('withdrawal_notes', gender: '4')}'),
            const SizedBox(height: 24),
            CustomWideButton(
              onTap: () async {
                final String requestUrl = dotenv.env['WITHDRAW']!;

                try {
                  final http.Response response = await http.get(
                    Uri.parse(requestUrl),
                    headers: {
                      'Authorization': userController.state.authorization
                    },
                  );
                  if (response.statusCode == 200) {
                    if (context.mounted) {
                      customShowDialog(
                        context: context,
                        title: context.tr('withdrawal_success'),
                        content: context.tr('withdrawal_success_message'),
                        onTap: () {
                          NavigatorKeyManager().pushNamedAndRemoveUntil(RouteNames.signIn);
                        }
                      );
                      PrefsManager().remove('saved_studentId');
                      PrefsManager().remove('saved_nickname');
                    }
                  } else {
                    if (context.mounted) {
                      customShowDialog(
                        context: context,
                        title: context.tr('error'),
                        content: context.tr('error_occured'),
                      );
                    }
                  }
                } catch (e) {
                  log(e.toString());
                  if (context.mounted) {
                    customShowDialog(
                      context: context,
                      title: context.tr('error'),
                      content: context.tr('error_occured'),
                    );
                  }
                }
              },
              buttonText: context.tr('withdrawal'),
              buttonColor: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }
}
