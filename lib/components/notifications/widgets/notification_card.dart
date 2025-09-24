import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/navigator/navigator_key_manager.dart';
import 'package:beat_flutter/managers/navigator/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/data_models.dart';
import '../../global/widgets/custom_rounded_bordered_container.dart';
import 'notification_content.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard(
    this.notificationModel, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomRoundedBorderedContainer(
        borderWidth: 0.5,
        color: context.appColors.background,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.w),
          child: NotificationContent(notificationModel: notificationModel),
        ),
      ),
    );
  }

  void onTap() {
    NavigatorKeyManager()
        .pushNamed(RouteNames.noticeDetail, arguments: notificationModel);
  }

  final NotificationModel notificationModel;
}
