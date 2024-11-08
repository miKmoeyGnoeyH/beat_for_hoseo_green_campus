import 'dart:developer';

import 'package:BEAT/app.dart';
import 'package:BEAT/data/states/qr_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../components/global/methods/custom_show_dialog.dart';

class QRProvider {
  final http.Client client = http.Client();

  Future<QRState> handleQRCreditRequest(
      String requestUrl, String authorization) async {
    QRState qrState;

    try {
      final http.Response response = await client.get(
        Uri.parse(requestUrl),
        headers: <String, String>{
          'Authorization': authorization,
        },
      );

      if (response.statusCode == 200) {
        log('qr_provider : handleQRCreditRequest() : response.body : ${response.body}');
        int credit = int.parse(response.body);

        if (credit >= 0) {
          qrState = QRSuccess(
            'reward_acquire_success'.tr(),
            'qr_scan_success_earned_neuro'.tr(args: [credit.toString()]),
          );
        } else {
          qrState = QRSuccess(
            'qr_scan_success'.tr(),
            'qr_scan_success_Deducted_neuro'.tr(args: [credit.toString()]),
          );
        }
      } else {
        log(response.body);
        switch (response.body) {
          case "\"ALREADY_GOT_CREDIT\"":
            qrState = QRFailure(
              'reward_acquire_failed'.tr(),
              'already_got_credit'.tr(),
            );
            break;
          case "\"NOT_ENOUGH_NEURO\"":
            qrState = QRFailure(
              'qr_scan_failed'.tr(),
              'not_enough_neuro'.tr(),
            );
            break;
          default:
            qrState = QRFailure(
              'qr_scan_failed'.tr(),
              'error_occured'.tr(),
            );
            break;
        }
      }
    } catch (e) {
      log(e.toString());
      qrState = QRFailure(
        'qr_scan_failed'.tr(),
        'error_occured'.tr(),
      );
    }
    return qrState;
  }
}
