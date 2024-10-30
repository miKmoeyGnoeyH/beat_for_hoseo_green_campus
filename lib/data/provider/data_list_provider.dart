import 'dart:convert';
import 'dart:developer';

import 'package:BEAT/data/models/data_models.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../states/data_list_state.dart';

enum DataListType { quest, quiz, survey }

class DataListProvider {
  final http.Client _httpClient = http.Client();

  Future<DataListState> fetchQuests(DataListType type) async {
    final String eventsUrl;

    switch (type) {
      case DataListType.quest:
        eventsUrl = dotenv.env['QUEST_LIST']!;
        break;
      case DataListType.quiz:
        eventsUrl = dotenv.env['QUIZ_LIST']!;
        break;
      case DataListType.survey:
      default:
        eventsUrl = dotenv.env['QUIZ_LIST']!;
        break;
    }

    try {
      final http.Response response = await _httpClient
          .get(Uri.parse(eventsUrl))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        List<DataModel> dataList = [];
        log(response.body);
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
          default:
            for (var data in body) {
              dataList.add(QuizModel.fromJson(data));
            }
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
