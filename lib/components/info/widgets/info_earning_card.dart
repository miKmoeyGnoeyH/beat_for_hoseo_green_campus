import 'package:BEAT/components/info/widgets/info_spending_list.dart';
import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../controller/info/controller/info_list_controller.dart';
import '../../../data/states/info_list_state.dart';
import '../../global/widgets/buttons/custom_refresh_button.dart';
import '../../global/widgets/custom_circular_progress_indicator.dart';
import '../../global/widgets/custom_rounded_bordered_container.dart';
import 'info_earning_list.dart';

class InfoListCard extends StatelessWidget {
  const InfoListCard(
    this.selectedIndex, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InfoListController, InfoListState>(
      builder: (context, state) {
        if (state is InfoListLoaded) {
          return CustomRoundedBorderedContainer(
            color: context.appColors.background,
            borderWidth: 0.5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: selectedIndex == 0
                  ? InfoEarningList(
                      state.infoList.earnings,
                    )
                  : InfoSpendingList(
                      state.infoList.spending,
                    ),
            ),
          );
        } else if (state is InfoListLoading) {
          return const CustomCircularProgressIndicator();
        } else {
          return const CustomRefreshButton();
        }
      },
    );
  }

  final int selectedIndex;
}
