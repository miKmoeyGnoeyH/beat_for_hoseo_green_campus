import 'dart:typed_data';

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

  Future<Uint8List> signToImage() async {
    final image = await handSignatureControl.toImage();
    if (image == null) return Uint8List(0);
    sign = image.buffer.asUint8List();
    return sign;
  }

  // TODO: 이미지 리사이즈 기능
  // Uint8List resizeImage(Uint8List data) {
  //   Uint8List resizedData = data;
  //   IMG.Image img = IMG.decodeImage(data);
  //   IMG.Image resized = IMG.copyResize(img, width: img.width*2, height: img.height*2);
  //   resizedData = IMG.encodeJpg(resized);
  //   return resizedData;
  // }

  Uint8List sign = Uint8List(0);
}
