
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

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
    return CustomRoundedBorderedContainer(
      borderWidth: 0.5,
      color: context.appColors.background,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NotificationContent(notificationModel: notificationModel),
          ],
        ),
      ),
    );
  }

  final NotificationModel notificationModel;
}