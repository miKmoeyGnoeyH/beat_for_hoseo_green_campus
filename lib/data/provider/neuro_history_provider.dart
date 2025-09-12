import 'dart:convert';
import 'dart:developer';


import 'package:beat_flutter/managers/dotenv/dotenv_manager.dart';
import 'package:http/http.dart' as http;

import '../models/neuro_history_model.dart';
import '../states/neuro_history_state.dart';

class NeuroHistoryProvider {
  final http.Client _httpClient = http.Client();

  Future<NeuroHistoryState> getNeuroHistoryList(String authorization) async {
    final String requestUrl = DotEnvManager().pointHistory;

    try {
      final http.Response httpResponse = await _httpClient.get(
        Uri.parse(requestUrl),
        headers: <String, String>{
          'Authorization': authorization,
        },
      );

      if (httpResponse.statusCode == 200) {
        final responseBody = jsonDecode(utf8.decode(httpResponse.bodyBytes));
        List<NeuroHistoryModel> neuroHistoryList = [];
        // log(responseBody.runtimeType.toString());

        for (var neuroHistory in responseBody) {
          neuroHistoryList.add(NeuroHistoryModel.fromJson(neuroHistory));
        }

        List<NeuroHistoryModel> neuroHistoryListReversed =  List.from(neuroHistoryList.reversed);
        return NeuroHistoryLoadingSuccess(neuroHistoryList);
      }
    } catch (e) {
      log(e.toString());
    }
    return NeuroHistoryLoadingError();
  }
}