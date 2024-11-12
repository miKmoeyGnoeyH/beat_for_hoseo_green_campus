import 'package:flutter/material.dart';

import '../../../managers/navigator/routes.dart';

class HomeSettingsButton extends StatelessWidget {
  const HomeSettingsButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      visualDensity: const VisualDensity(horizontal: -4),
      icon: const Icon(
        Icons.settings_outlined,
        size: 24,
      ),
      onPressed: () => Navigator.pushNamed(context, RouteNames.settings),
    );
  }
}