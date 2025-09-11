import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:beat_flutter/managers/dotenv/dotenv_manager.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:beat_flutter/managers/logger/beat_logger.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../managers/prefs/prefs_manager.dart';
import '../models/user_model.dart';

class UserProvider {
  final http.Client _httpClient = http.Client();
  final LocalizationManager localizationManager = LocalizationManager();

  Future<User> signIn(String studentId, String password) async {
    BEATLogger.d("UserProvider: signIn: studentId: $studentId, password: $password");

    final String requestUrl = DotEnvManager().signIn;
    User user = Guest();

    try {

      final http.Response response = await _httpClient.post(
        Uri.parse(requestUrl),
        body: {
          'studentId': studentId,
          // 'nickname': password,
          'password': password,
        },
      ).timeout(const Duration(seconds: 10));

      BEATLogger.d("UserProvider: signIn: response: ${response.body.toString()}");

      if (response.statusCode == 200) {
        PrefsManager().setValue<String>('saved_studentId', studentId);
        PrefsManager().setValue<String>('saved_nickname', password);

        // log("UserProvider: signIn: response.headers: ${response.headers.toString()}");
        final String authorization = response.headers['authorization']!;
        final int sendToTime = int.parse(response.headers["send_to_time"]!);

        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final String category = responseBody['category'];
        final String name = responseBody['name'];
        final String department = responseBody['department'];
        final String email = responseBody['email'];
        final String nickname = responseBody['nickname'];

        final String neuroesInHand = await myNeuro(authorization);

        // TODO: 나중에 서버에서 사용자 정보를 응답으로 줄건데, 그때 그걸로 바꾸기
        user = Member(
          authorization,
          category,
          studentId,
          name,
          department,
          email,
          nickname,
          neuroesInHand,
          sendToTime,
        );
      } else {
        user = ErrorUser(response.body);
      }
    } on TimeoutException {
      user = ErrorUser(localizationManager.errorsTimeout);
    }
    catch (e) {
      log("UserProvider : signIn : error : ${e.toString()}");
      user = ErrorUser(localizationManager.errorsConnectionError);
    }

    return user;
  }

  Future<bool> registerToken(String authorization, String token) async {
    final String requestUrl = '${dotenv.env['REGISTER_TOKEN']!}?token=$token';

    log(requestUrl);

    bool ret = false;

    try {
      final http.Response response = await _httpClient.get(
        Uri.parse(requestUrl),
        headers: {
          'Authorization': authorization,
        },
      );

      ret = response.statusCode == 200;
    } catch (e) {
      log(e.toString());
    }

    return ret;
  }

  Future<String> myNeuro(String authorization) async {
    final String requestUrl = dotenv.env['MY_NEURO']!;
    String ret = '';

    try {
      final http.Response response = await _httpClient.get(
        Uri.parse(requestUrl),
        headers: {
          'authorization': authorization,
        },
      );

      if (response.statusCode == 200) {
        ret = response.body;
      }
    } on Exception {
      ret = '';
    }
    return ret;
  }

  Future<http.Response> signUp(
      String category,
      String department,
      String studentId,
      String email,
      String name,
      String nickname,
      String password,
      String encodedSignFile) async {
    final String requestUrl = DotEnvManager().signUp;

    final http.Response response = await _httpClient.post(
      Uri.parse(requestUrl),
      body: {
        'category': category,
        'department': department,
        'studentId': studentId,
        'email': email,
        'name': name,
        'nickname': nickname,
        'password': password,
        'encodedSignFile': encodedSignFile,
      },
    ).timeout(const Duration(seconds: 5));

    return response;
  }
}
