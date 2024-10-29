import 'dart:typed_data';

import 'package:hand_signature/signature.dart';


class RegisterSignController {
  final HandSignatureControl handSignatureControl = HandSignatureControl(
    threshold: 5.0,
    smoothRatio: 1,
    velocityRange: 5.0,
  );

  RegisterSignController();

  Future<Uint8List> signToImage() async {
    var image = await handSignatureControl.toImage();
    return image!.buffer.asUint8List();
  }
}