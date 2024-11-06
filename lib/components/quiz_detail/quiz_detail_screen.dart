import 'dart:convert';
import 'dart:developer';

import 'package:BEAT/components/global/methods/custom_show_dialog.dart';
import 'package:BEAT/components/global/widgets/buttons/custom_bottom_appbar_button.dart';
import 'package:BEAT/components/global/widgets/texts/custom_label_large.dart';
import 'package:BEAT/controller/user_bloc.dart';
import 'package:BEAT/data/models/data_models.dart';
import 'package:BEAT/managers/navigator/navigator_key_manager.dart';
import 'package:BEAT/managers/navigator/routes.dart';
import 'package:BEAT/managers/navigator/routes.dart';
import 'package:BEAT/managers/navigator/routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controller/home/controllers/data_controller.dart';
import '../../controller/home/events/data_events.dart';
import '../../data/provider/quiz_submit_grading_provider.dart';
import '../../data/states/data_state.dart';
import '../detail/detail_label_and_title.dart';
import '../global/widgets/appbars/custom_empty_appbar.dart';
import '../global/widgets/buttons/custom_retry_button.dart';
import '../global/widgets/custom_scaffold.dart';
import 'widgets/quiz_question.dart';

class QuizDetailScreen extends StatelessWidget {
  const QuizDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DataDetailModelController dataDetailModelController =
        context.read<DataDetailModelController>();
    List<QuizQuestion> questionList = [];

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CustomScaffold(
        appBar: const CustomEmptyAppBar(),
        body: BlocBuilder<DataDetailModelController, DataDetailModelState>(
          builder: (context, state) {
            return state is DataDetailModelLoadingSuccess
                ? SingleChildScrollView(
                    child: Padding(
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
                              text: (state.dataModel! as QuizDetailModel)
                                  .content),
                          const SizedBox(height: 20),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: (state.dataModel! as QuizDetailModel)
                                .questionList
                                .length,
                            itemBuilder: (context, index) {
                              final QuizQuestion question = QuizQuestion(
                                quizDetailModel:
                                    (state.dataModel! as QuizDetailModel),
                                index: index,
                              );

                              questionList.add(question);
                              return question;
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                : state is DataDetailModelLoadingError
                    ? CustomRetryButton(
                        onTap: () => dataDetailModelController.add(
                          DataDetailRequest(),
                        ),
                      )
                    : const Center(child: CircularProgressIndicator());
          },
        ),
        bottomNavigationBar: CustomBottomAppbarButton(
          onTap: () async {
            await onSubmit(
              context: context,
              questionList: questionList,
              quizDetailModel: (dataDetailModelController.state.dataModel
                  as QuizDetailModel),
            );
          },
          text: context.tr('submit_and_grading'),
        ),
      ),
    );
  }

  Future<void> onSubmit(
      {required BuildContext context,
      required List<QuizQuestion> questionList,
      required QuizDetailModel quizDetailModel}) async {

    final QuizSubmitGradingProvider quizSubmitGradingProvider =
        QuizSubmitGradingProvider();
    List<Map<String, dynamic>> questionToMap = [];
    final String authorization = context.read<UserBloc>().state.authorization;

    for (QuizQuestion question in questionList) {
      Map<String, dynamic> questionToJson = question.questionToJson!();

      if (questionToJson.isEmpty) {
        customShowDialog(
            context: context, title: context.tr('error'), content: context.tr('submit_unanswered'));
        return;
      }
      questionToMap.add(questionToJson);
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    String result = await quizSubmitGradingProvider.submitGrading(
        quizDetailModel.quizId, questionToMap, authorization);

    if (context.mounted) {
      if (result.isEmpty) {
        await customShowDialog(
            context: context, title: context.tr('error'), content: context.tr('connection_error'));
      } else if (result == "\"ALREADY_CHECKED\"") {
        await customShowDialog(
            context: context, title: context.tr('error'), content: context.tr('submit_already_checked'));
      } else {
        List<String> resultSplit = result.split('\n');
        await customShowDialog(context: context, title: resultSplit.length > 1 ? resultSplit[0] : null, content: resultSplit.length > 1 ? resultSplit[1] : resultSplit[0]);
      }
    }
    NavigatorKeyManager().pop();
  }
}
