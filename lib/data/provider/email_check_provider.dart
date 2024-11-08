
import 'package:BEAT/data/states/email_state.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class EmailCheckProvider {
  final http.Client _httpClient = http.Client();

  Future<EmailState> emailRequest(String studentId) async {
    await Future.delayed(const Duration(seconds: 3));
    EmailState emailState = EmailNotSent();
    final String requestUrl = dotenv.env['EMAIL_REQUEST']!;

    try {
      final http.Response response = await _httpClient
          .get(Uri.parse(requestUrl).replace(queryParameters: {
            'studentId': studentId,
          }))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        emailState = EmailSent();
      } else {
        emailState = EmailError();
      }
    } catch (e) {
      emailState = EmailError();
    }

    return emailState;
  }
}
