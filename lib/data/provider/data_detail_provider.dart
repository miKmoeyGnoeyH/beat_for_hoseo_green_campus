import 'dart:convert';
import 'dart:developer';

import 'package:BEAT/data/models/data_models.dart';
import 'package:BEAT/data/states/data_state.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class DataDetailProvider {
  final http.Client _httpClient = http.Client();

  Future<DataDetailModelState> fetchData(DataModel dataModel) async {
    log(dataModel.toString());
    final String requestUrl;

    switch (dataModel.runtimeType) {
      case const (QuestModel):
        requestUrl = '${dotenv.env['QUEST_DETAIL']!}${(dataModel as QuestModel).eventId}';
        break;
      case const (QuizModel):
        requestUrl = '${dotenv.env['QUIZ_DETAIL']!}${(dataModel as QuizModel).quizId}';
        break;
      default:
        return DataDetailModelLoadingError();
    }

    try {
      final http.Response response = await _httpClient
          .get(Uri.parse(requestUrl))
          .timeout(const Duration(seconds: 5));

      log(response.body);

      if (response.statusCode == 200) {
        DataModel data;
        final body = jsonDecode(utf8.decode(response.bodyBytes));

        switch (dataModel.runtimeType) {
          case const (QuestModel):
            data = QuestDetailModel.fromModelAndJson(dataModel as QuestModel, body);
            break;
          case const (QuizModel):
            data = QuizDetailModel.fromModelAndJson(dataModel as QuizModel, body);
            break;
          default:
            return DataDetailModelLoadingError();
        }
        return DataDetailModelLoadingSuccess(data);
      } else {
        return DataDetailModelLoadingError();
      }
    } catch (e) {
      return DataDetailModelLoadingError();
    }
  }
}
