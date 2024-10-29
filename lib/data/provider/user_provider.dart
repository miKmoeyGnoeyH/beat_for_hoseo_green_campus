
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../managers/prefs/prefs_manager.dart';
import '../models/user_model.dart';

class UserProvider {
  final http.Client _httpClient = http.Client();

  Future<User> signIn(String studentId, String nickname) async {
    final String requestUrl = dotenv.env['SIGN_IN']!;
    User user = Guest();

    try {
      final http.Response response = await _httpClient.post(
        Uri.parse(requestUrl),
        body: {
          'studentId': studentId,
          'nickname': nickname,
        },
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        PrefsManager.setValue<String>('saved_studentId', studentId);
        PrefsManager.setValue<String>('saved_nickname', nickname);

        final String authorization = response.headers['authorization']!;
        final String neuroesInHand = await myNeuro(authorization);

        user = Member(studentId, nickname, authorization, neuroesInHand);
      } else {
        user = ErrorUser('sign_in_failed_message'.tr());
      }
    } catch (e) {
      user = ErrorUser('connection_error'.tr());
    }

    return user;
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
}
