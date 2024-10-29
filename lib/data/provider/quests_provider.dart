import 'dart:convert';
import 'dart:developer';

import 'package:BEAT/data/models/event_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class QuestsProvider {
  final http.Client _httpClient = http.Client();

  Future<QuestsState> fetchQuests() async {
    final String eventsUrl = dotenv.env['EVENT_LIST']!;

    try {
      final http.Response response =
          await _httpClient.get(Uri.parse(eventsUrl)).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        List<QuestModel> quests = [];
        log(response.body);
        final body = jsonDecode(utf8.decode(response.bodyBytes));

        for (var quest in body) {
          quests.add(QuestModel.fromJson(quest));
        }

        return QuestsLoadingSuccess(quests);
      } else {
        return QuestsLoadingError();
      }
    } catch (e) {
      return QuestsLoadingError();
    }
  }
}
