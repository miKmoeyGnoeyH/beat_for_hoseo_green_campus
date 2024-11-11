import 'package:BEAT/controller/register_fill_inform/register_sign_controller.dart';
import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:BEAT/managers/navigator/navigator_key_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hand_signature/signature.dart';

import '../../theme/texts/custom_texts.dart';
import '../global/widgets/custom_rounded_bordered_container.dart';
import '../global/widgets/custom_scaffold.dart';

class RegisterSignScreen extends StatefulWidget {
  const RegisterSignScreen(this.registerSignController, {super.key});

  final RegisterSignController registerSignController;

  @override
  State<RegisterSignScreen> createState() => _RegisterSignScreenState();
}

class _RegisterSignScreenState extends State<RegisterSignScreen> {
  RegisterSignController get registerSignController => widget.registerSignController;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    registerSignController.signToImage();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isScrollable: false,
      bottom: true,
      backgroundColor: context.appColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16.0),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: context.width,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black.withOpacity(0.3),
                        width: 0.33,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: HandSignature(
                      control: registerSignController.handSignatureControl,
                      color: context.appColors.onBackground,
                      width: 1.0,
                      maxWidth: 4.0,
                      type: SignatureDrawType.arc,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => registerSignController.handSignatureControl.clear(),
                      child: SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.refresh_rounded,
                            color: context.appColors.onBackground.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => NavigatorKeyManager().pop(),
              child: CustomRoundedBorderedContainer(
                color: context.appColors.primary,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      context.tr('done'),
                      style: CustomTexts.subtitleLarge
                          .copyWith(color: context.appColors.onPrimary),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
