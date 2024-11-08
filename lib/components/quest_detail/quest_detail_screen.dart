import 'package:BEAT/components/global/widgets/appbars/custom_empty_appbar.dart';
import 'package:BEAT/components/global/widgets/buttons/custom_refresh_button.dart';
import 'package:BEAT/components/global/widgets/custom_circular_progress_indicator.dart';
import 'package:BEAT/components/global/widgets/custom_scaffold.dart';
import 'package:BEAT/controller/home/controllers/data_controller.dart';
import 'package:BEAT/data/models/data_models.dart';
import 'package:BEAT/data/states/data_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../controller/home/events/data_events.dart';
import '../detail/detail_desc.dart';
import '../detail/detail_image.dart';
import '../detail/detail_label_and_title.dart';
import '../global/widgets/buttons/custom_retry_button.dart';
import 'widgets/quest_detail_table.dart';
import 'widgets/quest_detail_table_contents.dart';

class QuestDetailScreen extends StatefulWidget {
  const QuestDetailScreen({super.key});

  @override
  State<QuestDetailScreen> createState() => _QuestDetailScreenState();
}

class _QuestDetailScreenState extends State<QuestDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final DataDetailModelController dataDetailModelController =
        context.read<DataDetailModelController>();

    return CustomScaffold(
      appBar: const CustomEmptyAppBar(),
      body: BlocBuilder<DataDetailModelController, DataDetailModelState>(
        builder: (context, state) => state is DataDetailModelLoadingSuccess
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: ListView(
                  padding: const EdgeInsets.all(0),
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    DetailLabelAndTItle(
                      labelText: 'Quest',
                      title: (state.dataModel! as QuestDetailModel).eventName,
                    ),
                    const SizedBox(height: 20),
                    DetailImage(
                        imageUrl:
                            '${dotenv.env['QUEST_IMAGE']!}${(state.dataModel! as QuestDetailModel).eventId}'),
                    const SizedBox(height: 20),
                    DetailDesc(
                      description: (state.dataModel! as QuestDetailModel)
                          .descriptionLong,
                    ),
                    const SizedBox(height: 20),
                    QuestDetailTable(
                        child: QuestDetailTableContents(
                      state.dataModel! as QuestDetailModel,
                    )),
                  ],
                ),
              )
            : state is DataDetailModelLoadingError
                ? CustomRefreshButton(
                    onTap: () =>
                        dataDetailModelController.add(DataDetailRequest()),
                  )
                : const CustomCircularProgressIndicator(),
      ),
    );
  }
}
