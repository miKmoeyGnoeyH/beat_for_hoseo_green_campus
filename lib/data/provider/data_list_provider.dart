import 'dart:convert';
import 'dart:developer';

import 'package:beat_flutter/managers/dotenv/dotenv_manager.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/data_models.dart';
import '../states/data_list_state.dart';

enum DataListType { quest, quiz, survey, rank, notification }

class DataListProvider {
  final http.Client _httpClient = http.Client();

  Future<DataListState> fetchDataList(DataListType type, String authorization) async {
    final String requestUrl;

    switch (type) {
      case DataListType.quest:
        requestUrl = DotEnvManager().questList;
        // requestUrl = dotenv.env['QUEST_LIST']!;
        break;
      case DataListType.quiz:
        requestUrl = dotenv.env['QUIZ_LIST']!;
        break;
      case DataListType.rank:
        requestUrl = DotEnvManager().rankListUrl;
        // requestUrl = dotenv.env['RANK']!;
        break;
      case DataListType.survey:
        requestUrl = DotEnvManager().surveyList;
        // requestUrl = dotenv.env['SURVEY_LIST']!;
        break;
      case DataListType.notification:
        requestUrl = DotEnvManager().notice;
        // requestUrl = dotenv.env['NOTICE_LIST']!;
        break;
      default:
        requestUrl = "";
        // requestUrl = dotenv.env['SURVEY_LIST']!;
        break;
    }

    try {
      final http.Response response = await _httpClient.get(
        Uri.parse(requestUrl),
        headers: {"Authorization": authorization},
      ).timeout(
        const Duration(seconds: 5),
      );

      if (response.statusCode == 200) {
        List<DataModel> dataList = [];
        final body = jsonDecode(utf8.decode(response.bodyBytes));
        // final body = jsonDecode(response.body);
        // log(body.toString());

        switch (type) {
          case DataListType.quest:
            for (var data in body) {
              dataList.add(QuestModel.fromJson(data));
            }
            break;
          case DataListType.quiz:
            for (var data in body) {
              // log("DataListProvider : fetchDataList : body.toString : ${body.toString()}");
              dataList.add(QuizModel.fromJson(data));
            }
            break;
          case DataListType.survey:
            for (var data in body) {
              dataList.add(SurveyModel.fromJson(data));
            }
          case DataListType.rank:
            {
              // log("DataListProvider : fetchDataList : DataListType.rank : body.toString() : ${body.toString()}");
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
      log(e.toString());
      // log(s.toString());
      return DataListLoadingError();
    }
  }

  Future<DataListState> fetchQuestListTest() async {
    List<DataModel> questList = [];
    final json =
        await rootBundle.loadString("assets/dummy/event_list_dummy.json");
    final body = jsonDecode(json);

    for (var data in body) {
      questList.add(QuestModel.fromJson(data));
    }

    return DataListLoadingSuccess(questList);
  }

  Future<DataListState> fetchSurveyListTest() async {
    List<DataModel> questList = [];
    final json =
        await rootBundle.loadString("assets/dummy/survey_list_dummy.json");
    final body = jsonDecode(json);

    for (var data in body) {
      questList.add(SurveyModel.fromJson(data));
    }

    return DataListLoadingSuccess(questList);
  }
}
