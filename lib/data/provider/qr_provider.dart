import 'dart:developer';

import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;

import '../states/qr_state.dart';

class QRProvider {
  final http.Client client = http.Client();

  Future<QRState> handleQRCheckRequest(
      String requestUrl, String authorization, double lat, double lng) async {
    final LocalizationManager localizationManager = LocalizationManager();
    QRState qrState;

    try {
      final http.Response response = await client.post(
        Uri.parse(requestUrl),
        headers: <String, String>{
          'Authorization': authorization,
        },
        body: {
          "latitude": lat,
          "longitude": lng,
        }
      );

      if (response.statusCode == 200) {
        int credit = int.parse(response.body);

        if (credit >= 0) {
          qrState = QRSuccess(
            localizationManager.qrRewardAcquireSuccess,
            localizationManager.qrQRScanSuccessEarnedPoint(credit.toString()),
          );
        } else {
          qrState = QRSuccess(
            localizationManager.qrQRScanSuccess,
            localizationManager.qrQRScanSuccessDeductedPoint(credit.toString()),
          );
        }
      } else {
        qrState = QRFailure(
          localizationManager.qrQRScanFailed,
          localizationManager.qrAlreadyChecked,
        );
      }
    } catch (e) {
      log(e.toString());
      qrState = QRFailure(
        localizationManager.qrQRScanFailed,
        localizationManager.qrErrorOccured,
      );
    }
    return qrState;
  }

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

  Future<QRState> handleQRSignRequest(
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
        qrState = QRSuccess(
          'sign_success'.tr(),
          response.body,
        );
      } else {
        qrState = QRFailure(
          'sign_failed'.tr(),
          'already_signed'.tr(),
        );
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
