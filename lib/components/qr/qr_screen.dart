import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:app_settings/app_settings.dart';
import 'package:beat_flutter/components/qr/widgets/overlay.dart';
import 'package:beat_flutter/controller/home/controllers/quest_list_controller.dart';
import 'package:beat_flutter/controller/home/controllers/survey_detail_controller.dart';
import 'package:beat_flutter/controller/home/events/data_events.dart';
import 'package:beat_flutter/controller/location/location_controller.dart';
import 'package:beat_flutter/controller/screen_holder/page_index_controller.dart';
import 'package:beat_flutter/exception/beat_exception.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:beat_flutter/managers/logger/beat_logger.dart';
import 'package:beat_flutter/managers/navigator/navigator_key_manager.dart';
import 'package:beat_flutter/managers/navigator/routes.dart';
import 'package:beat_flutter/managers/permission/permission_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;

import '../../controller/user_controller.dart';
import '../global/methods/custom_show_dialog.dart';
import '../global/widgets/custom_circular_progress_indicator.dart';
import '../global/widgets/regexp/qr_filter.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({super.key});

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  MobileScannerController mobileScannerController = MobileScannerController();

  final PageIndexController pageIndexController =
      Get.find<PageIndexController>();
  final LocalizationManager localizationManager = LocalizationManager();
  final LocationController locationController = Get.find<LocationController>();
  Timer? scanTimer;

  @override
  void initState() {
    mobileScannerController = MobileScannerController();
    // showDialogIfCameraPermissionDenied();
    super.initState();
  }

  void startScanTimer() {
    scanTimer = Timer(const Duration(seconds: 3), () {
      scanTimer?.cancel();
    });
  }

  @override
  void dispose() {
    scanTimer?.cancel();
    mobileScannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserController userBloc = context.read<UserController>();

    return Stack(
      children: [
        MobileScanner(
          controller: mobileScannerController,
          scanWindow: Rect.fromCenter(
            center: MediaQuery.sizeOf(context).center(const Offset(0, -100)),
            width: 220,
            height: 220,
          ),
          onDetect: (BarcodeCapture capture) async {
            if (scanTimer != null && scanTimer!.isActive) return;

            if (isScanning) return;

            isScanning = true;

            final List<Barcode> barcodes = capture.barcodes;
            final Barcode barcode = barcodes.first;

            if (barcode.rawValue == null) return;

            final String requestUrl = barcode.rawValue!;
            log("requestUrl : $requestUrl");

            if (qrRawValueFilterRelease.hasMatch(requestUrl)) {
            // if (qrRawValueFilterDebug.hasMatch(requestUrl)) {
              customConfirmDialog(
                context: context,
                title: localizationManager.qrScanTitle,
                content: localizationManager.qrScanContent,
                onCancelTap: () {
                  isScanning = false;
                  startScanTimer();
                },
                onConfirmTap: () async {
                  log(requestUrl);

                  http.Response? response;

                  response = await Get.showOverlay(
                    asyncFunction: () async {
                      try {
                        if (locationController.locationData == null ||
                            locationController.locationData?.lat == null ||
                            locationController.locationData?.lng == null) {
                          throw BEATException(
                            localizationManager.qrLocationFetchErrorTitle,
                            localizationManager.qrLocationFetchErrorContent,
                          );
                        }

                        BEATLogger.d(
                            "QrScreen : onDetect : latitude : ${locationController.locationData!.lat}, longitude : ${locationController.locationData!.lng}");

                        return await http
                            .post(
                              Uri.parse(requestUrl),
                              headers: <String, String>{
                                'Authorization': userBloc.state.authorization,
                                'Content-Type': 'application/json',
                              },
                              body: jsonEncode({
                                "latitude":
                                    locationController.locationData!.lat,
                                "longitude":
                                    locationController.locationData!.lng,
                              }),
                            )
                            .timeout(
                              const Duration(seconds: 5),
                            );
                      } on BEATException {
                        return null;
                      } catch (e) {
                        log("Get.showOverlay 내부 에러: $e");
                        return null; // 꼭 리턴해야 자동으로 다이얼로그가 닫힘
                      }
                    },
                    loadingWidget: const CustomCircularProgressIndicator(),
                  );

                  if (response != null) {
                    if (response.statusCode == 200) {
                      await customShowDialog(
                          context: context,
                          title: localizationManager.qrQRScanSuccess,
                          content: response.body,
                          onTap: () {
                            final UserController userController =
                                context.read<UserController>();
                            userController.add(GetMyNeuro());
                            context
                                .read<QuestListController>()
                                .add(DataListRequest());

                            pageIndexController
                                .setIndex(pageIndexController.homeIndex);
                          });
                    } else {
                      await customShowDialog(
                        context: context,
                        title: localizationManager.qrQRScanFailed,
                        content: response.body,
                      );
                    }
                  }

                  isScanning = false;
                  startScanTimer();
                },
              );
              } else if (qrSurveyFilterRelease.hasMatch(requestUrl)) {
            // } else if (qrSurveyFilterDebug.hasMatch(requestUrl)) {
              await customConfirmDialog(
                context: context,
                title: localizationManager.qrSurveyQRTitle,
                content: localizationManager.qrSurveyQRContent,
                onConfirmTap: () {
                  final match = qrSurveyFilterRelease.firstMatch(requestUrl);
                  // final match = qrSurveyFilterDebug.firstMatch(requestUrl);
                  final String surveyId = match!.group(1)!;

                  Get.find<SurveyDetailController>().surveyId =
                      int.parse(surveyId);
                  Get.find<SurveyDetailController>().fetchSurveyDetail();

                  NavigatorKeyManager().pushNamed(RouteNames.surveyDetail);

                  pageIndexController.setIndex(pageIndexController.homeIndex);

                  isScanning = false;
                  startScanTimer();
                },
              );
            } else {
              await customShowDialog(
                context: context,
                title: localizationManager.qrInvalidQRTitle,
                content: localizationManager.qrInvalidQRContent,
              );

              isScanning = false;
              startScanTimer();
            }
          },
        ),
        Container(
          decoration: ShapeDecoration(
            shape: QROverlay(
              borderColor: context.appColors.primary,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutWidth: 200,
              cutOutHeight: 200,
            ),
          ),
        ),
      ],
    );
  }

  bool isScanning = false;
}
