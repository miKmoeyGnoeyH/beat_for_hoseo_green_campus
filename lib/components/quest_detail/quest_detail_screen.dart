import 'package:BEAT/components/global/widgets/appbars/custom_empty_appbar.dart';
import 'package:BEAT/components/global/widgets/custom_scaffold.dart';
import 'package:BEAT/controller/home/data_controller.dart';
import 'package:BEAT/data/models/data_models.dart';
import 'package:BEAT/data/states/data_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../detail/detail_desc.dart';
import '../detail/detail_image.dart';
import '../detail/detail_label_and_title.dart';
import 'widgets/quest_detail_table.dart';
import 'widgets/quest_detail_table_contents.dart';

class QuestDetailScreen extends StatelessWidget {
  const QuestDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomEmptyAppBar(),
      body: BlocBuilder<DataDetailModelController, DataDetailModelState>(
        builder: (context, state) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: ListView(
            padding: const EdgeInsets.all(0),
            physics: const NeverScrollableScrollPhysics(),
            children: [
              DetailLabelAndTItle(
                labelText: 'Quest',
                title: state is DataDetailModelLoadingSuccess
                    ? (state.dataModel! as QuestDetailModel).eventName
                    : '',
              ),
              const SizedBox(height: 20),
              DetailImage(
                imageUrl: state is DataDetailModelLoadingSuccess
                    ? '${dotenv.env['QUEST_IMAGE']!}${(state.dataModel! as QuestDetailModel).eventId}'
                    : null,
              ),
              const SizedBox(height: 20),
              DetailDesc(
                  description: state is DataDetailModelLoadingSuccess
                      ? (state.dataModel! as QuestDetailModel).descriptionLong
                      : ''),
              const SizedBox(height: 20),
              QuestDetailTable(
                child: state is DataDetailModelLoadingSuccess
                    ? QuestDetailTableContents(
                        state.dataModel! as QuestDetailModel,
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}