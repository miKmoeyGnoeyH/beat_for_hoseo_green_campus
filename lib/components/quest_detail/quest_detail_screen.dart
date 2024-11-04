import 'package:BEAT/components/global/widgets/appbars/custom_empty_appbar.dart';
import 'package:BEAT/components/global/widgets/custom_scaffold.dart';
import 'package:BEAT/controller/home/data_controller.dart';
import 'package:BEAT/data/models/data_models.dart';
import 'package:BEAT/data/states/data_state.dart';
import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../controller/home/data_events.dart';
import '../detail/detail_desc.dart';
import '../detail/detail_image.dart';
import '../detail/detail_label_and_title.dart';
import '../global/widgets/buttons/custom_wide_button.dart';
import 'widgets/quest_detail_table.dart';
import 'widgets/quest_detail_table_contents.dart';

class QuestDetailScreen extends StatelessWidget {
  const QuestDetailScreen({super.key});

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
                ? Center(
                    child: Column(
                      children: [
                        Text(context.tr('connection_error')),
                        CustomWideButton(
                          onTap: () {
                            dataDetailModelController.add(DataDetailRequest());
                          },
                          buttonText: context.tr('retry'),
                          buttonColor: context.appColors.primary,
                        ),
                      ],
                    ),
                  )
                : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
