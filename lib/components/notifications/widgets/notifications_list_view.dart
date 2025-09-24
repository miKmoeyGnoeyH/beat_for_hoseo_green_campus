
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/data_models.dart';
import 'notification_card.dart';

class NotificationsListView extends StatelessWidget {
  const NotificationsListView({
    super.key,
    required this.notificationList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 16.w),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: notificationList.length,
      // itemCount: 20,
      separatorBuilder: (BuildContext context, int index) =>
          SizedBox(height: 16.w),
      itemBuilder: (BuildContext context, int index) =>
          NotificationCard(notificationList[index] as NotificationModel),
          // NotificationCard(NotificationModel(noticeId: 0, title: "test", body: "test", createdAt: DateTime.now())),
    );
  }

  final List<DataModel> notificationList;
}
