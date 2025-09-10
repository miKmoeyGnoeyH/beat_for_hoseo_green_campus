import 'package:beat_flutter/components/global/widgets/texts/custom_title_medium.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../data/models/data_models.dart';
import '../../global/widgets/texts/custom_body_large.dart';

class NotificationContent extends StatelessWidget {
  const NotificationContent({
    super.key,
    required this.notificationModel,
  });

  final NotificationModel notificationModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTitleMedium(
          text: notificationModel.title,
        ),
        const SizedBox(height: 10),
        CustomBodyLarge(
          text: DateFormat("yyyy-MM-dd hh:mm:ss")
              .format(notificationModel.createdAt),
          textColor: context.appColors.disabled,
        )
      ],
    );
  }
}
