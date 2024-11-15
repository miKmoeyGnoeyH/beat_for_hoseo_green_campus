
import 'package:Beat/extensions/buildcontext_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controller/notification/notification_controller.dart';
import '../../data/states/data_list_state.dart';
import '../global/widgets/appbars/custom_empty_appbar.dart';
import '../global/widgets/buttons/custom_refresh_button.dart';
import '../global/widgets/custom_circular_progress_indicator.dart';
import '../global/widgets/custom_scaffold.dart';
import '../global/widgets/texts/custom_display_medium.dart';
import 'widgets/notifications_list_view.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationsController notificationsController = context.read<NotificationsController>();

    return CustomScaffold(
      appBar: const CustomEmptyAppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          CustomDisplayMedium(
            text: context.tr('notifications'),
            textColor: context.appColors.defaultTextColor,
          ),
          BlocBuilder<NotificationsController, DataListState>(
            builder: (context, state) {
              if (state is DataListLoadingSuccess) {
                return NotificationsListView(
                  notificationList:
                  notificationsController.state.dataList,
                );
              } else if (state is DataListLoading) {
                return const CustomCircularProgressIndicator();
              } else {
                return CustomRefreshButton(onTap: () {});
              }
            },
          ),
        ],
      ),
    );
  }
}
