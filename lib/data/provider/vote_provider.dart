import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/data_models.dart';
import '../states/data_state.dart';
import '../states/vote_list_state.dart';

class VoteProvider {
  final http.Client _httpClient = http.Client();

  Future<VoteListState> fetchVoteList(String authorization) async {
    final String requestUrl = dotenv.env['VOTTING_LIST']!;
    VoteListState voteListState = VoteListInitial();
    ChoiceVoteModel.initCache();

    try {
      final http.Response response = await _httpClient
          .get(Uri.parse(requestUrl), headers: <String, String>{
        'Authorization': authorization,
      }).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final body = jsonDecode(utf8.decode(response.bodyBytes));


        voteListState = VoteListLoadingSuccess(VoteList.fromJson(body));
      } else {
        voteListState = VoteListLoadingError();
      }
    } catch (e) {
      voteListState = VoteListLoadingError();
    }
    return voteListState;
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
        dotenv.env['VOTTING_DETAIL']! + voteModel.bettingId.toString();

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
