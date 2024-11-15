import 'dart:convert';


import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/data_models.dart';
import '../states/data_list_state.dart';

enum DataListType { quest, quiz, survey, rank, notification }

class DataListProvider {
  final http.Client _httpClient = http.Client();

  Future<DataListState> fetchDataList(DataListType type) async {
    final String requestUrl;

    switch (type) {
      case DataListType.quest:
        requestUrl = dotenv.env['QUEST_LIST']!;
        break;
      case DataListType.quiz:
        requestUrl = dotenv.env['QUIZ_LIST']!;
        break;
      case DataListType.rank:
        requestUrl = dotenv.env['RANK']!;
        break;
      case DataListType.survey:
        requestUrl = dotenv.env['SURVEY_LIST']!;
        break;
      case DataListType.notification:
        requestUrl = dotenv.env['NOTICE_LIST']!;
        break;
      default:
        requestUrl = dotenv.env['SURVEY_LIST']!;
        break;
    }

    try {
      final http.Response response = await _httpClient
          .get(Uri.parse(requestUrl))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        List<DataModel> dataList = [];
        final body = jsonDecode(utf8.decode(response.bodyBytes));

        switch (type) {
          case DataListType.quest:
            for (var data in body) {
              dataList.add(QuestModel.fromJson(data));
            }
            break;
          case DataListType.quiz:
            for (var data in body) {
              dataList.add(QuizModel.fromJson(data));
            }
            break;
          case DataListType.survey:
            for (var data in body) {
              dataList.add(SurveyModel.fromJson(data));
            }
          case DataListType.rank:
            {
              for (var data in body) {
                dataList.add(RankModel.fromJson(data));
              }
            }
          case DataListType.notification:
            {
              for (var data in body) {
                dataList.add(NotificationModel.fromJson(data));
              }
            }
          default:
            break;
        }
        return DataListLoadingSuccess(dataList);
      } else {
        return DataListLoadingError();
      }
    } catch (e) {
      return DataListLoadingError();
    }
  }
}
