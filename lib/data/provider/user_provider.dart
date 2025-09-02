import 'dart:developer';

import 'package:beat_flutter/managers/dotenv/dotenv_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../managers/prefs/prefs_manager.dart';
import '../models/user_model.dart';

class UserProvider {
  final http.Client _httpClient = http.Client();

  Future<User> signIn(String studentId, String password) async {
    log("UserProvider : signIn : studentId : $studentId, nickname : $password");
    final String requestUrl = dotenv.env['SIGN_IN']!;
    User user = Guest();

    try {
      final http.Response response = await _httpClient.post(
        Uri.parse(requestUrl),
        body: {
          'studentId': studentId,
          // 'nickname': password,
          'password': password,
        },
      ).timeout(const Duration(seconds: 5));

      log(response.toString());

      if (response.statusCode == 200) {
        PrefsManager().setValue<String>('saved_studentId', studentId);
        PrefsManager().setValue<String>('saved_nickname', password);

        final String authorization = response.headers['authorization']!;
        
        log("UserProvider: signIn: response.headers: ${response.headers.toString()}");
        final int sendToTime = int.parse(response.headers["send_to_time"]!);
        final String neuroesInHand = await myNeuro(authorization);

        // TODO: 나중에 서버에서 사용자 정보를 응답으로 줄건데, 그때 그걸로 바꾸기
        user = Member(
          studentId,
          studentId,
          neuroesInHand,
          authorization,
          sendToTime,
        );
      } else {
        user = ErrorUser('sign_in_failed_message'.tr());
      }
    } catch (e) {
      log("UserProvider : signIn : error : ${e.toString()}");
      user = ErrorUser('connection_error'.tr());
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
        // 'email': email,
        'name': name,
        'nickname': nickname,
        'password': password,
        'encodedSignFile': encodedSignFile,
      },
    ).timeout(const Duration(seconds: 5));

    return response;
  }
}
