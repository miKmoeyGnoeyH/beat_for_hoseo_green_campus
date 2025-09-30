import 'dart:convert';
import 'dart:developer';

import 'package:beat_flutter/managers/dotenv/dotenv_manager.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class RankListProvider {
  final http.Client _httpClient = http.Client();

  Future<Map<String, dynamic>> getRankList(String authorization) async {
    final String requestUrl = DotEnvManager().rankListUrl;

    try {
      final http.Response response =
          await http.get(Uri.parse(requestUrl), headers: {
        'Authorization': authorization,
      }).timeout(
        const Duration(seconds: 5),
      );

      log("RankListProvider : getRankList : response.statusCode : ${response.statusCode}");
      log("RankListProvider : getRankList : response.body : ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception();
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getRankListTest(
      String authorization) async {
    final String requestUrl = DotEnvManager().rankListUrl;

    try {
      final http.Response pointResponse = await _httpClient.get(
          Uri.parse(requestUrl),
          headers: {"Authorization": authorization}).timeout(
        const Duration(seconds: 5),
      );

      if (pointResponse.statusCode == 200) {
        final pointBody = pointResponse.body;
        final stepResponse = await rootBundle
            .loadString("assets/dummy/step_count_rank_dummy.json");

        // log("RankListProvider : getRankListTest : stepResponse : $stepResponse");

        List<Map<String, dynamic>> retMap = [];
        final Map<String, dynamic> pointMap = {
          "type": "point",
          "data": jsonDecode(pointBody)
        };
        final Map<String, dynamic> stepMap = {
          "type": "step",
          "data": jsonDecode(stepResponse)
        };

        retMap.add(pointMap);
        retMap.add(stepMap);

        return retMap;
      } else {
        throw Exception();
      }
    } catch (e) {
      log("RankListProvider : getRankList : error : $e");
      rethrow;
    }
  }
}
