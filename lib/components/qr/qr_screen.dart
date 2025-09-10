import 'dart:developer';

import 'package:beat_flutter/components/qr/widgets/overlay.dart';
import 'package:beat_flutter/controller/location/location_controller.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../controller/qr/qr_controller.dart';
import '../../controller/qr/qr_event.dart';
import '../../controller/user_controller.dart';
import '../../data/states/qr_state.dart';
import '../../managers/navigator/navigator_key_manager.dart';
import '../global/methods/custom_show_dialog.dart';
import '../global/widgets/custom_circular_progress_indicator.dart';
import '../global/widgets/regexp/qr_filter.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({super.key});

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  final MobileScannerController mobileScannerController =
      MobileScannerController();

  final LocalizationManager localizationManager = LocalizationManager();
  final LocationController locationController = Get.find<LocationController>();

  @override
  Widget build(BuildContext context) {
    final UserController userBloc = context.read<UserController>();

    return BlocProvider(
      create: (context) => QRController(),
      child: Builder(builder: (context) {
        return BlocListener<QRController, QRState>(
          listener: (context, state) async {
            if (state is QRLoading) {
              setState(() {
                isScanning = true;
              });
              showDialog(
                  context: context,
                  builder: (context) =>
                      const CustomCircularProgressIndicator());
            } else if (state is QRSuccess) {
              await customShowDialog(
                  context: context, title: state.title, content: state.content);
              NavigatorKeyManager().pop();
              setState(() {
                isScanning = false;
              });
              userBloc.add(GetMyNeuro());
            } else if (state is QRFailure) {
              await customShowDialog(
                  context: context, title: state.title, content: state.content);
              NavigatorKeyManager().pop();
              setState(() {
                isScanning = false;
              });
            }
          },
          child: Stack(
            children: [
              MobileScanner(
                controller: mobileScannerController,
                // overlayBuilder: (context, boxConstraints) => Center(
                //   child: Container(
                //     decoration: BoxDecoration(
                //
                //     ),
                //   ),
                // ),
                scanWindow: Rect.fromCenter(
                  center:
                      MediaQuery.sizeOf(context).center(const Offset(0, -50)),
                  width: 200,
                  height: 200,
                ),
                onDetect: (BarcodeCapture capture) {
                  if (isScanning) return;

                  final List<Barcode> barcodes = capture.barcodes;
                  final Barcode barcode = barcodes.first;

                  if (barcode.rawValue == null) return;

                  final String requestUrl = barcode.rawValue!;
                  final QRController qrController =
                      context.read<QRController>();
                  log(requestUrl);

                  if (locationController.locationData == null ||
                      locationController.locationData?.lat == null ||
                      locationController.locationData?.lng == null) {
                    customShowDialog(
                      context: context,
                      title: localizationManager.qrLocationFetchErrorTitle,
                      content: localizationManager.qrLocationFetchErrorContent,
                    );
                    return;
                  }

                  if (qrRawValueFileterCheck.hasMatch(requestUrl)) {
                    qrController.add(
                      QRCheck(
                        requestUrl,
                        userBloc.state.authorization,
                        locationController.locationData!.lat,
                        locationController.locationData!.lng,
                      ),
                    );
                  } else if (qrRawValueFileterCredit.hasMatch(requestUrl)) {
                    qrController.add(
                      QRCredit(
                        requestUrl,
                        userBloc.state.authorization,
                        locationController.locationData!.lat,
                        locationController.locationData!.lng,
                      ),
                    );
                  } else if (qrRawValueFileterSign.hasMatch(requestUrl)) {
                    qrController.add(
                      QRSign(
                        requestUrl,
                        userBloc.state.authorization,
                        locationController.locationData!.lat,
                        locationController.locationData!.lng,
                      ),
                    );
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
          ),
          // SizedBox.expand(
          //   child: MobileScanner(
          //     controller: mobileScannerController,
          //     // overlayBuilder: (context, boxConstraints) => Center(
          //     //   child: Container(
          //     //     decoration: BoxDecoration(
          //     //
          //     //     ),
          //     //   ),
          //     // ),
          //     scanWindow: Rect.fromCenter(
          //       center:
          //       MediaQuery.sizeOf(context).center(const Offset(0, -50)),
          //       width: 300,
          //       height: 300,
          //     ),
          //     onDetect: (BarcodeCapture capture) {
          //       if (isScanning) return;
          //
          //       final List<Barcode> barcodes = capture.barcodes;
          //       final Barcode barcode = barcodes.first;
          //
          //       if (barcode.rawValue == null) return;
          //
          //       final String requestUrl = barcode.rawValue!;
          //       final QRController qrController =
          //       context.read<QRController>();
          //       log(requestUrl);
          //
          //       if (qrRawValueFileterCheck.hasMatch(requestUrl)) {
          //         qrController.add(
          //           QRCheck(
          //             requestUrl,
          //             userBloc.state.authorization,
          //           ),
          //         );
          //       } else if (qrRawValueFileterCredit.hasMatch(requestUrl)) {
          //         qrController.add(
          //           QRCredit(
          //             requestUrl,
          //             userBloc.state.authorization,
          //           ),
          //         );
          //       } else if (qrRawValueFileterSign.hasMatch(requestUrl)) {
          //         qrController.add(
          //           QRSign(
          //             requestUrl,
          //             userBloc.state.authorization,
          //           ),
          //         );
          //       }
          //     },
          //   ),
          // ),
        );
      }),
    );
  }

  bool isScanning = false;
}
