import 'package:BEAT/components/global/widgets/appbars/custom_empty_appbar.dart';
import 'package:BEAT/components/global/widgets/buttons/custom_refresh_button.dart';
import 'package:BEAT/components/global/widgets/custom_circular_progress_indicator.dart';
import 'package:BEAT/components/global/widgets/custom_scaffold.dart';
import 'package:BEAT/controller/rank/rank_controller.dart';
import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/states/data_list_state.dart';
import '../global/widgets/texts/custom_body_large.dart';
import '../global/widgets/texts/custom_display_medium.dart';
import 'widgets/ranking_list_view.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RankController rankController = context.read<RankController>();

    return CustomScaffold(
      appBar: const CustomEmptyAppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          CustomDisplayMedium(
            text: context.tr('ranking'),
            textColor: context.appColors.defaultTextColor,
          ),
          CustomBodyLarge(text: context.tr('ranking_desc')),
          BlocBuilder<RankController, DataListState>(
            builder: (context, state) {
              if (state is DataListLoadingSuccess) {
                return RankingListView(
                  rankingList:
                      rankController.state.dataList,
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
