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
    return Row(
      children: [
        CustomBodyLarge(
          text: notificationModel.toString(),
        )
      ],
    );
  }
}