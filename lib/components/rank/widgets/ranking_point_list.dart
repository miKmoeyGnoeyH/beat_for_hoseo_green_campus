import 'package:beat_flutter/components/global/widgets/buttons/custom_refresh_button.dart';
import 'package:beat_flutter/components/global/widgets/custom_circular_progress_indicator.dart';
import 'package:beat_flutter/components/rank/widgets/ranking_list_view.dart';
import 'package:beat_flutter/controller/home/events/data_events.dart';
import 'package:beat_flutter/controller/rank/rank_controller.dart';
import 'package:beat_flutter/data/states/data_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RankingPointList extends StatelessWidget {
  const RankingPointList({super.key});

  @override
  Widget build(BuildContext context) {
    final RankController rankController = context.read<RankController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: BlocBuilder<RankController, DataListState>(
        builder: (context, state) {
          if (state is DataListLoadingSuccess) {
            return RankingListView(
              rankingList: rankController.state.dataList,
            );
          } else if (state is DataListLoading) {
            return const CustomCircularProgressIndicator();
          } else {
            return CustomRefreshButton(onTap: () {
              rankController.add(DataListRequest());
            });
          }
        },
      ),
    );
  }
}
