import 'package:BEAT/components/global/widgets/texts/custom_label_large.dart';
import 'package:BEAT/data/models/data_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controller/home/data_controller.dart';
import '../../data/states/data_state.dart';
import '../detail/detail_label_and_title.dart';
import '../global/widgets/appbars/custom_empty_appbar.dart';
import '../global/widgets/buttons/custom_retry_button.dart';
import '../global/widgets/custom_scaffold.dart';
import 'widgets/quiz_question_objective.dart';
import 'widgets/quiz_question_subjective.dart';

class QuizDetailScreen extends StatelessWidget {
  const QuizDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DataDetailModelController dataDetailModelController =
        context.read<DataDetailModelController>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CustomScaffold(
        appBar: const CustomEmptyAppBar(),
        body: BlocBuilder<DataDetailModelController, DataDetailModelState>(
          builder: (context, state) {
            return state is DataDetailModelLoadingSuccess
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
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
                            text:
                                (state.dataModel! as QuizDetailModel).content),
                        const SizedBox(height: 20),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: (state.dataModel! as QuizDetailModel)
                              .questionList
                              .length,
                          itemBuilder: (context, index) {
                            return (state.dataModel! as QuizDetailModel)
                                    .questionList[index]
                                    .subjective
                                ? QuizQuestionSubjective(
                                    quizDetailModel:
                                        (state.dataModel! as QuizDetailModel),
                                    index: index,
                                  )
                                : QuizQuestionObjective(
                                    quizDetailModel:
                                        (state.dataModel! as QuizDetailModel),
                                    index: index,
                                  );
                          },
                        ),
                      ],
                    ),
                  )
                : state is DataDetailModelLoadingError
                    ? CustomRetryButton(
                        dataDetailModelController: dataDetailModelController)
                    : const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
