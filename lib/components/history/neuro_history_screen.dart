
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../controller/neuro_history/controllers/neuro_history_controller.dart';
import '../../controller/neuro_history/events/neuro_history_event.dart';
import '../../data/states/neuro_history_state.dart';
import '../global/widgets/appbars/custom_empty_appbar.dart';
import '../global/widgets/buttons/custom_refresh_button.dart';
import '../global/widgets/custom_circular_progress_indicator.dart';
import '../global/widgets/custom_scaffold.dart';
import '../global/widgets/texts/custom_body_large.dart';
import '../global/widgets/texts/custom_display_medium.dart';
import 'widgets/neuro_history_list_view.dart';

class NeuroHistoryScreen extends StatefulWidget {
  const NeuroHistoryScreen({super.key});

  @override
  State<NeuroHistoryScreen> createState() => _NeuroHistoryScreenState();
}

class _NeuroHistoryScreenState extends State<NeuroHistoryScreen> {
  final LocalizationManager localizationManager = LocalizationManager();

  @override
  Widget build(BuildContext context) {
    final NeuroHistoryController neuroHistoryController =
        context.read<NeuroHistoryController>();

    return CustomScaffold(
      appBar: const CustomEmptyAppBar(),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.w),
        children: [
          CustomDisplayMedium(
            text: localizationManager.historyHistory,
            textColor: context.appColors.defaultTextColor,
          ),
          CustomBodyLarge(text: localizationManager.historyHistoryDesc),
          BlocBuilder<NeuroHistoryController, NeuroHistoryState>(
            builder: (context, state) {
              if (state is NeuroHistoryLoadingError) {
                return SizedBox(
                  height: 500.w,
                  child: CustomRefreshButton(
                      onTap: () =>
                          neuroHistoryController.add(NeuroHistoryRequestEvent())),
                );
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
          SizedBox(height: 60.w),
        ],
      ),
    );
  }
}
