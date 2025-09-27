import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hand_signature/signature.dart';

class RegisterSignController {
  final HandSignatureControl handSignatureControl = HandSignatureControl(
    initialSetup: const SignaturePathSetup(
      threshold: 5.0,
      smoothRatio: 1,
      velocityRange: 5.0,
    ),
  );

  RegisterSignController();

  Future<void> done() async {
    ByteData? signature =
        await handSignatureControl.toImage(background: Colors.transparent);
    if (signature == null) {
      throw Exception();
    }
    signatureBase64 = base64Encode(signature.buffer.asUint8List());
  }

  String signatureBase64 = '';
}
