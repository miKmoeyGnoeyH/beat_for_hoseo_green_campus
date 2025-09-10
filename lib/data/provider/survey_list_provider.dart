import 'dart:convert';
import 'dart:developer';

import 'package:beat_flutter/data/models/data_models.dart';
import 'package:beat_flutter/data/states/data_list_state.dart';
import 'package:beat_flutter/managers/dotenv/dotenv_manager.dart';
import 'package:beat_flutter/managers/logger/beat_logger.dart';
import 'package:http/http.dart' as http;

class SurveyListProvider {
  Future<DataListState> fetchSurveyList() async {
    final String requestUrl = DotEnvManager().surveyList;

    try {
      final http.Response response =
          await http.get(Uri.parse(requestUrl)).timeout(
                const Duration(seconds: 5),
              );

      if (response.statusCode == 200) {
        List<SurveyModel> dataList = [];
        final body = jsonDecode(utf8.decode(response.bodyBytes));
        // final body = jsonDecode(response.body);
        BEATLogger.d("SurveyListProvider : fetchSurveyList : body.toString : ${body.toString()}");

        for (var data in body) {
          dataList.add(SurveyModel.fromJson(data));
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
}
