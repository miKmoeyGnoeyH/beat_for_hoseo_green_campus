import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../states/email_state.dart';

class IDCheckProvider {
  final http.Client _httpClient = http.Client();

  Future<IDState> emailRequest(String studentId) async {
    await Future.delayed(const Duration(seconds: 3));
    IDState emailState = IDNotSent();
    final String requestUrl = dotenv.env['EMAIL_REQUEST']!;

    try {
      final http.Response response = await _httpClient
          .get(Uri.parse(requestUrl).replace(queryParameters: {
            'studentId': studentId,
          }))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        emailState = IDSent();
      } else {
        emailState = IDError();
      }
    } catch (e) {
      emailState = IDError();
    }

    return emailState;
  }

  Future<IDState> idRequest(String id) async {
    await Future.delayed(const Duration(seconds: 3));
    IDState idState = IDNotSent();
    final String requestUrl = dotenv.env['ID_CHECK']!;

    try {
      final http.Response response = await _httpClient
          .get(Uri.parse(requestUrl).replace(queryParameters: {
        'id': id,
      }))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        idState = IDSent();
      } else {
        idState = IDError();
      }
    } catch (e) {
      idState = IDError();
    }

    return idState;
  }
}
