import 'package:BEAT/components/global/widgets/appbars/custom_empty_appbar.dart';
import 'package:BEAT/components/global/widgets/custom_scaffold.dart';
import 'package:BEAT/components/global/widgets/texts/custom_body_large.dart';
import 'package:BEAT/components/global/widgets/texts/custom_display_medium.dart';
import 'package:BEAT/controller/neuro_history/controllers/neuro_history_controller.dart';
import 'package:BEAT/controller/neuro_history/events/neuro_history_event.dart';
import 'package:BEAT/data/models/neuro_history_model.dart';
import 'package:BEAT/data/states/neuro_history_state.dart';
import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../global/widgets/buttons/custom_refresh_button.dart';
import '../global/widgets/custom_circular_progress_indicator.dart';
import 'widgets/neuro_history_card.dart';

class NeuroHistoryScreen extends StatefulWidget {
  const NeuroHistoryScreen({super.key});

  @override
  State<NeuroHistoryScreen> createState() => _NeuroHistoryScreenState();
}

class _NeuroHistoryScreenState extends State<NeuroHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final NeuroHistoryController neuroHistoryController =
        context.read<NeuroHistoryController>();

    return CustomScaffold(
      appBar: const CustomEmptyAppBar(),
      body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            CustomDisplayMedium(
              text: context.tr('history'),
              textColor: context.appColors.defaultTextColor,
            ),
            CustomBodyLarge(text: context.tr('history_desc')),
            BlocBuilder<NeuroHistoryController, NeuroHistoryState>(
              builder: (context, state) {
                if (state is NeuroHistoryLoadingError) {
                  return CustomRefreshButton(
                      onTap: () => neuroHistoryController
                          .add(NeuroHistoryRequestEvent()));
                } else if (state is NeuroHistoryLoading) {
                  return const CustomCircularProgressIndicator();
                } else {
                  return NeuroHistoryListView(
                    neuroHistoryList:
                        neuroHistoryController.state.neuroHistoryList,
                  );
                }
              },
            ),
          ]),
    );
  }
}

class NeuroHistoryListView extends StatelessWidget {
  const NeuroHistoryListView({
    super.key,
    required this.neuroHistoryList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: neuroHistoryList.length,
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 10),
      itemBuilder: (BuildContext context, int index) =>
          NeuroHistoryCard(neuroHistoryList[index]),
    );
  }

  final List<NeuroHistoryModel> neuroHistoryList;
}
