import 'dart:convert';
import 'dart:developer';

import 'package:beat_flutter/managers/dotenv/dotenv_manager.dart';
import 'package:http/http.dart' as http;

class MyPageProvider {
  Future<Map<String, dynamic>> getMyRank(String authorization) async {
    final String requestUrl = DotEnvManager().myRankUrl;

    try {
      final http.Response response =
          await http.get(Uri.parse(requestUrl), headers: {
        'Authorization': authorization,
      }).timeout(const Duration(seconds: 5));

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

  Future<Map<String, dynamic>> getWalkMeanHistory(String authorization) async {
    final String requestUrl = DotEnvManager().walkMeanHistory;

    try {
      final http.Response response =
      await http.get(Uri.parse(requestUrl), headers: {
        'Authorization': authorization,
      }).timeout(const Duration(seconds: 5));

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
}
