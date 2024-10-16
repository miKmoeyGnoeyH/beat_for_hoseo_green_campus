import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/widgets/global/custom_scaffold.dart';
import 'package:beat_flutter/widgets/global/rounded_bordered_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../business/user_bloc.dart';
import '../widgets/global/basic_appbar.dart';

class SettingsPage extends StatelessWidget {
  final UserBloc _userBloc = UserBloc();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: BasicAppBar(
        iconTheme: IconThemeData(color: context.colorScheme.primary),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr('settings'),
              style: context.textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => _userBloc.add(SignOut()),
              child: RoundedBorderedContainer(
                color: context.colorScheme.primary,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      context.tr('sign_out'),
                      style: context.textTheme.titleLarge!
                          .copyWith(color: context.colorScheme.onPrimary),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SettingsPage({super.key});
}
