import 'package:BEAT/components/global/widgets/buttons/custom_wide_button.dart';
import 'package:BEAT/components/global/widgets/custom_rounded_bordered_container.dart';
import 'package:BEAT/components/global/widgets/custom_text_field.dart';
import 'package:BEAT/components/global/widgets/texts/custom_label_large.dart';
import 'package:BEAT/components/global/widgets/texts/custom_subtitle_large.dart';
import 'package:BEAT/data/models/data_models.dart';
import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controller/home/data_controller.dart';
import '../../controller/home/data_events.dart';
import '../../data/states/data_state.dart';
import '../detail/detail_label_and_title.dart';
import '../global/widgets/appbars/custom_empty_appbar.dart';
import '../global/widgets/custom_scaffold.dart';
import '../global/widgets/texts/custom_body_large.dart';

class QuizDetailScreen extends StatelessWidget {
  const QuizDetailScreen({super.key});

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DetailLabelAndTItle(
                      labelText: 'Quiz',
                      title: (state.dataModel! as QuizDetailModel).title,
                      neuro: (state.dataModel! as QuizDetailModel).neuro,
                    ),
                    const SizedBox(height: 20),
                    CustomLabelLarge(
                        text: (state.dataModel! as QuizDetailModel).content),
                    const SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: (state.dataModel! as QuizDetailModel)
                          .questionList
                          .length,
                      itemBuilder: (context, index) => Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomSubtitleLarge(
                                text: 'Q. ${index + 1}',
                                textColor: context.appColors.primary,
                              ),
                              CustomBodyLarge(
                                text: (state.dataModel! as QuizDetailModel)
                                        .questionList[index]
                                        .subjective
                                    ? context.tr('subjective')
                                    : context.tr('objective'),
                                textColor: context.appColors.primary,
                              )
                            ],
                          ),
                          const SizedBox(height: 5),
                          CustomRoundedBorderedContainer(
                            color: context.appColors.background,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomSubtitleLarge(
                                      text:
                                          (state.dataModel! as QuizDetailModel)
                                              .questionList[index]
                                              .question),
                                  (state.dataModel! as QuizDetailModel)
                                          .questionList[index]
                                          .subjective
                                      ? CustomTextField(
                                          hintText:
                                              context.tr('writing_answers'),
                                        )
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          itemCount: (state.dataModel!
                                                  as QuizDetailModel)
                                              .questionList[index]
                                              .answerList
                                              .length,
                                          itemBuilder: (context, jndex) =>
                                              CustomBodyLarge(
                                            text: (state.dataModel!
                                                    as QuizDetailModel)
                                                .questionList[index]
                                                .answerList[jndex]
                                                .answer,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
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
