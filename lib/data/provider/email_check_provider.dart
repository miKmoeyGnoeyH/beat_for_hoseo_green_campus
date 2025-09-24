import 'dart:convert';
import 'dart:developer';

import 'package:beat_flutter/managers/dotenv/dotenv_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../states/email_state.dart';

class IDCheckProvider {
  final http.Client _httpClient = http.Client();

  Future<IDState> emailRequest(String email, String category) async {
    // await Future.delayed(const Duration(seconds: 3));
    IDState emailState = IDNotSent();
    final String requestUrl = DotEnvManager().emailRequest;

    // log("IDCheckProvider : emailRequest : requestUrl : $requestUrl, email : $email, category : $category");

    try {
      final http.Response response = await _httpClient
          .get(Uri.parse(requestUrl).replace(queryParameters: {
            'email': email,
            'category': category,
          }))
          .timeout(const Duration(seconds: 10));

      // log("IDCheckProvider : emailRequest : response : ${response.body}");

      if (response.statusCode == 200) {
        emailState = IDSent();
      } else {
        emailState = IDError(response.body);
        throw Exception();
      }
    } catch (e) {
      log(e.toString());
    }

    return emailState;
  }

  Future<IDState> emailVerify(String email) async {
    IDState emailState = IDNotSent();
    final String requestUrl = DotEnvManager().emailVerify;

    log("IDCheckProvider : emailVerify : requestUrl : $requestUrl, email : $email");

    try {
      final http.Response response = await _httpClient
          .get(Uri.parse(requestUrl).replace(queryParameters: {
            'email': email,
          }))
          .timeout(const Duration(seconds: 10));

      log("IDCheckProvider : emailVerify : response : ${response.body}");

      if (response.statusCode == 200) {
        if (jsonDecode(response.body) == true) {
          emailState = IDEmailChecked();
        } else {
          emailState = IDEmailNotChecked();
        }
      } else {
        throw Exception();
      }
    } catch (e) {
      log(e.toString());
      emailState = IDEmailCheckError("");
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

      log("IDCheckProvider : idRequest : response : $response");

      if (response.statusCode == 200) {
        idState = IDSent();
      } else {
        idState = IDError(response.body);
        throw Exception();
      }
    } catch (e) {
      log(e.toString());
    }

    return idState;
  }
}
