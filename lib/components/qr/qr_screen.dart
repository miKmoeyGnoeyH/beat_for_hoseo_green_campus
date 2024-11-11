import 'dart:developer';

import 'package:BEAT/controller/qr/qr_controller.dart';
import 'package:BEAT/components/global/methods/custom_show_dialog.dart';
import 'package:BEAT/components/global/widgets/custom_circular_progress_indicator.dart';
import 'package:BEAT/components/global/widgets/regexp/qr_filter.dart';
import 'package:BEAT/managers/navigator/navigator_key_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../controller/qr/qr_event.dart';
import '../../controller/user_controller.dart';
import '../../data/states/qr_state.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({super.key});

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  final MobileScannerController mobileScannerController =
      MobileScannerController();

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
          child: MobileScanner(
            controller: mobileScannerController,
            // overlayBuilder: (context, boxConstraints) => Center(
            //   child: Container(
            //     decoration: BoxDecoration(
            //
            //     ),
            //   ),
            // ),
            onDetect: (BarcodeCapture capture) {
              if (isScanning) return;

              final List<Barcode> barcodes = capture.barcodes;
              final Barcode barcode = barcodes.first;

              if (barcode.rawValue == null) return;

              final String requestUrl = barcode.rawValue!;
              final QRController qrController = context.read<QRController>();
              log(requestUrl);

              if (qrRawValueFileterCheck.hasMatch(requestUrl)) {
                qrController.add(
                  QRCheck(
                    requestUrl,
                    userBloc.state.authorization,
                  ),
                );
              } else if (qrRawValueFileterCredit.hasMatch(requestUrl)) {
                qrController.add(
                  QRCredit(
                    requestUrl,
                    userBloc.state.authorization,
                  ),
                );
              } else if (qrRawValueFileterSign.hasMatch(requestUrl)) {
                qrController.add(
                  QRSign(
                    requestUrl,
                    userBloc.state.authorization,
                  ),
                );
              }
            },
          ),
        );
      }),
    );
  }

  bool isScanning = false;
}
