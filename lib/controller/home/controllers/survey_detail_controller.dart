import 'package:beat_flutter/data/models/data_models.dart';
import 'package:beat_flutter/data/repository/survey_detail_repository.dart';
import 'package:beat_flutter/exception/beat_exception.dart';
import 'package:beat_flutter/managers/logger/beat_logger.dart';
import 'package:get/get.dart';

class SurveyDetailController extends GetxController with StateMixin {
  final Rx<bool> _isAnsweredEveryQuestion = false.obs;
  bool get isAnsweredEveryQuestion => _isAnsweredEveryQuestion.value;
  set isAnsweredEveryQuestion(bool value) => _isAnsweredEveryQuestion.value = value;
  int? surveyId;

  SurveyDetailController() {
    change(null, status: RxStatus.empty());
  }

  Future<void> fetchSurveyDetail() async {
    change(null, status: RxStatus.loading());
    isAnsweredEveryQuestion = false;

    if (surveyId == null) {
      change(state, status: RxStatus.error());
      return;
    }

    try {
      final SurveyDetailModel surveyDetailModel = await surveyDetailRepository
          .fetchSurveyDetail(surveyId!);
      change(surveyDetailModel, status: RxStatus.success());
    } on BEATException {
      change(state, status: RxStatus.error());
    } catch (e) {
      BEATLogger.d("SurveyDetailController : fetchSurveyDetail : error : ${e.toString()}");
      change(state, status: RxStatus.error());
      rethrow;
    }
  }

  void updateIsAnsweredEveryQuestion() {
    final SurveyDetailModel? surveyDetailModel = state as SurveyDetailModel?;
    if (surveyDetailModel == null) {
      isAnsweredEveryQuestion = false;
    }

    for (final SurveyQuestionModel question in surveyDetailModel!.questionList) {
      if (question.selectedAnswerIndex == null) {
        isAnsweredEveryQuestion = false;
      }
    }

    isAnsweredEveryQuestion = true;
  }

  List<Map<String, dynamic>> answersToJson() {
    final SurveyDetailModel? surveyDetailModel = state as SurveyDetailModel?;
    if (surveyDetailModel == null) {
      return [];
    }

    final List<Map<String, dynamic>> answers = [];

    for (final SurveyQuestionModel question in surveyDetailModel.questionList) {
      if (question.selectedAnswerIndex == null) {
        continue;
      }

      answers.add({
        "surveyQuestionId": question.surveyQuestionId,
        "answerId":
            question.answerList[question.selectedAnswerIndex!].answerId,
        "description": question.answerList[question.selectedAnswerIndex!].description
      });
    }

    return answers;
  }

  final SurveyDetailRepository surveyDetailRepository = SurveyDetailRepository();
}