import 'package:beat_flutter/managers/navigator/navigator_key_manager.dart';
import 'package:beat_flutter/managers/navigator/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeNotificationsButton extends StatelessWidget {
  const HomeNotificationsButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      visualDensity: const VisualDensity(horizontal: -4),
      icon: Icon(
        Icons.notifications_none_rounded,
        size: 24.w,
      ),
      onPressed: () {
        NavigatorKeyManager().pushNamed(RouteNames.notifications);
      },
    );
  }
}
