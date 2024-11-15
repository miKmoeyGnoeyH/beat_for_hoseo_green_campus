import 'dart:convert';
import 'dart:developer';


import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/neuro_history_model.dart';
import '../states/neuro_history_state.dart';

class NeuroHistoryProvider {
  final http.Client _httpClient = http.Client();

  Future<NeuroHistoryState> getNeuroHistoryList(String authorization) async {
    final String requestUrl = dotenv.env['NEURO_HISTORY']!;

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

        for (var neuroHistory in responseBody) {
          neuroHistoryList.add(NeuroHistoryModel.fromJson(neuroHistory));
        }

        List<NeuroHistoryModel> neuroHistoryListReversed =  List.from(neuroHistoryList.reversed);
        return NeuroHistoryLoadingSuccess(neuroHistoryListReversed);
      }
    } catch (e) {
      log(e.toString());
    }
    return NeuroHistoryLoadingError();
  }
}