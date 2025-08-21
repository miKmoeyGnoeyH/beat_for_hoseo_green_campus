import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class QuizSubmitGradingProvider {
  final http.Client _httpClient = http.Client();

  Future<String> submitGrading(int quizId,
      List<Map<String, dynamic>> questionToMap, String authorization) async {
    String result = '';

    final String submitUrl = '${dotenv.env['QUIZ_SUBMIT']}${quizId.toString()}';

    final String gradingUrl =
        '${dotenv.env['QUIZ_GRADING']}${quizId.toString()}';

    try {
      final http.Response answerSubmitResponse = await _httpClient
          .post(
            Uri.parse(submitUrl),
            headers: {
              "Content-Type": "application/json",
              "Authorization": authorization
            },
            body: jsonEncode(questionToMap),
          )
          .timeout(const Duration(seconds: 5));

      if (answerSubmitResponse.statusCode == 200) {
        final http.Response answerGradingResponse = await _httpClient
            .get(Uri.parse(gradingUrl), headers: {
          "Authorization": authorization
        }).timeout(const Duration(seconds: 5));

        if (answerGradingResponse.statusCode == 200) {
          result = answerGradingResponse.body;
        }
      }
    } catch (e) {
      log(e.toString());
    }

    // 정답입니다!
    // 10뉴로 획득!

    // "ALREADY_CHECKED"

    log(result);

    return result;
  }
}
