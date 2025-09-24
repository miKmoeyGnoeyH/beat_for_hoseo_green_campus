import 'package:beat_flutter/components/global/methods/custom_show_dialog.dart';
import 'package:beat_flutter/controller/register_fill_inform/register_sign_controller.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:beat_flutter/managers/navigator/navigator_key_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  RegisterSignController get registerSignController =>
      widget.registerSignController;

  final LocalizationManager localizationManager = LocalizationManager();

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isScrollable: false,
      bottom: true,
      backgroundColor: context.appColors.background,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.h),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      width: context.width,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: context.appColors.borderColor,
                          width: 0.33,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: HandSignature(
                        control: registerSignController.handSignatureControl,
                        color: context.appColors.onBackground,
                        width: 1.0,
                        maxWidth: 5.0,
                        type: SignatureDrawType.arc,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () =>
                          registerSignController.handSignatureControl.clear(),
                      child: SizedBox(
                        child: Padding(
                          padding: EdgeInsets.all(10.h),
                          child: Icon(
                            Icons.refresh_rounded,
                            color: context.appColors.borderColor,
                            size: 80.h,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            GestureDetector(
              onTap: () async {
                if (registerSignController.handSignatureControl.isFilled) {
                  try {
                    // await registerSignController.signToImage();
                    await registerSignController.done();
                    NavigatorKeyManager().pop();
                  } catch (e) {
                    if (context.mounted) {
                      customShowDialog(
                        context: context,
                        title: localizationManager.signSignFailed,
                        content: localizationManager
                            .signFailedToConvertSignatureContent,
                      );
                    }
                  }
                } else {
                  NavigatorKeyManager().pop();
                }
              },
              child: CustomRoundedBorderedContainer(
                width: 1100.h,
                color: context.appColors.primary,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.h),
                    child: Text(
                      localizationManager.generalDone,
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
