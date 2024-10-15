import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

import '../widgets/global/basic_appbar.dart';
import '../widgets/global/custom_scaffold.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      hasScrollBody: false,
      appBar: BasicAppBar(
        title: 'Sign In',
        textColor: context.colorScheme.onPrimary,
      ),
      body: const Center(
        child: Column(
          children: [
            TextField(),
            TextField(),
          ],
        ),
      ),
    );
  }

  const SignInPage({super.key});
}
