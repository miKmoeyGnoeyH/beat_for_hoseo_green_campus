import 'dart:convert';
import 'dart:developer';

import 'package:beat_flutter/managers/dotenv/dotenv_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/data_models.dart';
import '../states/data_state.dart';

class DataDetailProvider {
  final http.Client _httpClient = http.Client();

  Future<DataDetailModelState> fetchData(DataModel dataModel) async {
    // log("DataDetailProvider : fetchData()");
    // log("DataDetailProvider : fetchData() : dataModel.toString() : ${dataModel.toString()}");

    final String requestUrl;

    if (dataModel.runtimeType == QuestQRModel) {
      requestUrl =
          '${DotEnvManager().questQRDetailUrl}/${(dataModel as QuestQRModel).eventId}';
    } else if (dataModel.runtimeType == QuestWalkModel) {
      requestUrl =
          '${DotEnvManager().questWalkDetailUrl}/${(dataModel as QuestWalkModel).eventId}';
    } else if (dataModel.runtimeType == QuizModel) {
      requestUrl =
          '${dotenv.env['QUIZ_DETAIL']!}${(dataModel as QuizModel).quizId}';
    } else {
      return DataDetailModelLoadingError();
    }

    // log("DataDetailProvider : fetchData() : requestUrl : $requestUrl");

    try {
      final http.Response response = await _httpClient
          .get(Uri.parse(requestUrl))
          .timeout(const Duration(seconds: 5));

      log("DataDetailProvider : fetchData() : response.body : ${response.body.toString()}");

      if (response.statusCode == 200) {
        DataModel data;
        // log(response.body.toString());
        final body = jsonDecode(utf8.decode(response.bodyBytes));

        switch (dataModel.runtimeType) {
          case const (QuestQRModel):
            data = QuestDetailModel.fromJson(body, true);
            break;
          case const (QuestWalkModel):
            data = QuestDetailModel.fromJson(body, true);
            break;
          case const (QuizModel):
            data =
                QuizDetailModel.fromModelAndJson(dataModel as QuizModel, body);
            break;
          default:
            return DataDetailModelLoadingError();
        }
        return DataDetailModelLoadingSuccess(data);
      } else if (response.statusCode == 400) {
        DataModel data;
        // log(response.body.toString());
        final body = jsonDecode(utf8.decode(response.bodyBytes));

        switch (dataModel.runtimeType) {
          case const (QuestQRModel):
            data = QuestDetailModel.fromJson(body, false);
            break;
          case const (QuestWalkModel):
            data = QuestDetailModel.fromJson(body, false);
            break;
          case const (QuizModel):
            data =
                QuizDetailModel.fromModelAndJson(dataModel as QuizModel, body);
            break;
          default:
            return DataDetailModelLoadingError();
        }
        return DataDetailModelLoadingSuccess(data);
      } else {
        return DataDetailModelLoadingError();
      }
    } catch (e) {
      log("DataDetailProvider : fetchData : error : ${e.toString()}");
      return DataDetailModelLoadingError();
    }
  }
}
