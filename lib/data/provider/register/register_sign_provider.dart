import 'dart:typed_data';

import 'package:BEAT/data/provider/register/register_agreement_provider.dart';
import 'package:hand_signature/signature.dart';

class RegisterSignProvider {
  final HandSignatureControl handSignatureControl = HandSignatureControl(
    threshold: 5.0,
    smoothRatio: 1,
    velocityRange: 5.0,
  );

  RegisterSignProvider(this.registerAgreementProvider);

  Future<Uint8List> signToImage() async {
    var image = await handSignatureControl.toImage();
    return image!.buffer.asUint8List();
  }

  RegisterAgreementProvider registerAgreementProvider;
}