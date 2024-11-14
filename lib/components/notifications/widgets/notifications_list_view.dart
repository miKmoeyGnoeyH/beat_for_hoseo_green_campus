import 'package:BEAT/data/models/data_models.dart';
import 'package:flutter/material.dart';

import 'notification_card.dart';

class NotificationsListView extends StatelessWidget {
  const NotificationsListView({
    super.key,
    required this.notificationList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: notificationList.length,
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 10),
      itemBuilder: (BuildContext context, int index) =>
          NotificationCard(notificationList[index] as NotificationModel),
    );
  }

  final List<DataModel> notificationList;
}
