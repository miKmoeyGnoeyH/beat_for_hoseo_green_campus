import 'package:BEAT/data/states/nickname_state.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class NicknameCheckProvider {
  final http.Client _httpClient = http.Client();

  Future<NicknameState> emailRequest(String nickname) async {
    await Future.delayed(const Duration(seconds: 3));
    NicknameState nicknameState = NicknameNotChecked();
    final String requestUrl = dotenv.env['NICKNAME_CHECK']!;

    try {
      final http.Response response = await _httpClient
          .get(Uri.parse(requestUrl).replace(queryParameters: {
        'nickname': nickname,
      }))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        nicknameState = NicknameChecked();
      } else if (response.statusCode == 400) {
        nicknameState = NicknameAlreadyTaken();
      } else {
        nicknameState = NicknameError();
      }
    } catch (e) {
      nicknameState = NicknameError();
    }

    return nicknameState;
  }
}