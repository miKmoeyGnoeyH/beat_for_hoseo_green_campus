
import 'package:Beat/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

import '../../../managers/navigator/navigator_key_manager.dart';
import '../../../managers/navigator/routes.dart';

class HomeInformationButton extends StatelessWidget {
  const HomeInformationButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      visualDensity: const VisualDensity(horizontal: -4),
      icon: Icon(
        Icons.info_outline_rounded,
        color: context.appColors.onSurface,
        size: 24,
      ),
      onPressed: () {
        NavigatorKeyManager().pushNamed(RouteNames.info);
      },
    );
  }
}