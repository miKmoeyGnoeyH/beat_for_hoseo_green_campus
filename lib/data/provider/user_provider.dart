import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';

class UserProvider {
  final http.Client _httpClient = http.Client();

  Future<User> signIn(String studentId, String nickname) async {
    final String requestUrl = dotenv.env['SIGN_IN']!;

    try {
      final http.Response response = await _httpClient.post(
        Uri.parse(requestUrl),
        headers: {
          'studentId': studentId,
          'nickname': nickname,
        },
      );

      if (response.statusCode == 200) {
        return Member(studentId, nickname, response.headers['Authorization']!);
      }
    } catch (e) {
      return Guest();
    }
    return Guest();
  }

  Future<bool> emailRequest(String studentId) async {
    final String requestUrl = dotenv.env['EMAIL_REQUEST']!;

    try {
      final http.Response response = await _httpClient.get(
        Uri.parse(requestUrl),
        headers: {
          'studentId': studentId,
        },
      );

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<bool> idCheck(String id) async {
    final String requestUrl = dotenv.env['ID_CHECK']!;

    try {
      final http.Response response = await _httpClient.get(
        Uri.parse(requestUrl),
        headers: {
          'id': id,
        },
      );

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<bool> nicknameCheck(String nickname) async {
    final String requestUrl = dotenv.env['NICKNAME_CHECK']!;

    try {
      final http.Response response = await _httpClient.get(
        Uri.parse(requestUrl),
        headers: {
          'nickname': nickname,
        },
      );

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  // TODO: Implement this method
  Future<void> register(
      String studentId, String nickname, String department) async {}
}
