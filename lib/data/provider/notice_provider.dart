import 'dart:convert';
import 'dart:developer';

import 'package:beat_flutter/data/models/data_models.dart';
import 'package:beat_flutter/data/states/data_list_state.dart';
import 'package:beat_flutter/managers/dotenv/dotenv_manager.dart';
import "package:http/http.dart" as http;

class NoticeProvider {
  Future<DataListState> fetchDataList(String authorization) async {
    final String requestUrl = DotEnvManager().notice;

    try {
      final http.Response response = await http.get(
        Uri.parse(requestUrl),
        headers: {"Authorization": authorization},
      ).timeout(
        const Duration(seconds: 5),
      );

      if (response.statusCode == 200) {
        List<DataModel> dataList = [];
        final body = jsonDecode(utf8.decode(response.bodyBytes));
        // final body = jsonDecode(response.body);
        log(body.toString());

        for (var data in body) {
          dataList.add(NotificationModel.fromJson(data));
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
