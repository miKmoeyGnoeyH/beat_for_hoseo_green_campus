import 'dart:convert';
import 'dart:developer';

import 'package:BEAT/data/states/data_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/data_models.dart';
import '../states/data_list_state.dart';

class VoteProvider {
  final http.Client _httpClient = http.Client();

  Future<DataListState> fetchVoteList() async {
    final String requestUrl = dotenv.env['VOTTING_LIST']!;

    try {
      final http.Response response = await _httpClient
          .get(Uri.parse(requestUrl))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        List<DataModel> dataList = [];
        final body = jsonDecode(utf8.decode(response.bodyBytes));
        for (var data in body) {
          dataList.add(VoteModel.fromJson(data));
        }
        return DataListLoadingSuccess(dataList);
      } else {
        return DataListLoadingError();
      }
    } catch (e) {
      log(e.toString());
      return DataListLoadingError();
    }
  }

  Future<DataDetailModelState> fetchVoteResult(
      VoteModel voteModel, String authorization) async {
    final String requestUrl =
        dotenv.env['VOTTING_RESULT']! + voteModel.bettingId.toString();

    try {
      final http.Response response = await _httpClient
          .get(Uri.parse(requestUrl), headers: <String, String>{
        'Authorization': authorization,
      }).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        DataModel data;
        final body = jsonDecode(utf8.decode(response.bodyBytes));

        data = VoteResultModel.fromModelAndJson(voteModel, body);

        return DataDetailModelLoadingSuccess(data);
      } else {
        return DataDetailModelLoadingError();
      }
    } catch (e) {
      debugPrint(e.toString());
      return DataDetailModelLoadingError();
    }
  }

  Future<DataDetailModelState> fetchVoteDetail(VoteModel voteModel) async {
    final String requestUrl =
        dotenv.env['VOTTING_RESULT']! + voteModel.bettingId.toString();

    try {
      final http.Response response = await _httpClient
          .get(Uri.parse(requestUrl))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        DataModel data;
        final body = jsonDecode(utf8.decode(response.bodyBytes));

        data = VoteDetailModel.fromModelAndJson(voteModel, body);

        return DataDetailModelLoadingSuccess(data);
      } else {
        return DataDetailModelLoadingError();
      }
    } catch (e) {
      debugPrint(e.toString());
      return DataDetailModelLoadingError();
    }
  }
}
