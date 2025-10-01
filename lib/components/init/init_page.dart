import 'dart:developer';
import 'dart:io';

import 'package:app_version_update/app_version_update.dart';
import 'package:beat_flutter/components/global/methods/custom_show_dialog.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/dotenv/dotenv_manager.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:beat_flutter/managers/navigator/navigator_key_manager.dart';
import 'package:beat_flutter/managers/navigator/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:url_launcher/url_launcher.dart';

class InitPage extends StatefulWidget {
  InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  final LocalizationManager localizationManager = LocalizationManager();

  @override
  void initState() {
    super.initState();
    // 첫 프레임 이후에 실행(컨텍스트/네비 안정)
    WidgetsBinding.instance.addPostFrameCallback((_) => checkUpdate());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.primary,
      body: SizedBox.expand(
        child: Center(
          child: Image.asset("assets/images/beat_hgc_splash_android12.png"),
        ),
      ),
    );
  }

  // 외부 앱(앱스토어/플레이스토어)로 여는 공용 함수
  Future<void> _openStore({
    required String iosHttpsUrl,   // e.g. https://apps.apple.com/app/idxxxx
    required String androidPkgId,  // e.g. com.example.app
  }) async {
    if (Platform.isIOS) {
      final itms = Uri.parse(iosHttpsUrl.replaceFirst('https://', 'itms-apps://'));
      // 1차: itms-apps (앱스토어 앱), 2차: https (사파리) — 모두 외부앱 모드
      if (!await launchUrl(itms, mode: LaunchMode.externalApplication)) {
        await launchUrl(Uri.parse(iosHttpsUrl), mode: LaunchMode.externalApplication);
      }
    } else {
      final market = Uri.parse('market://details?id=$androidPkgId');
      if (!await launchUrl(market, mode: LaunchMode.externalApplication)) {
        final web = Uri.parse('https://play.google.com/store/apps/details?id=$androidPkgId');
        await launchUrl(web, mode: LaunchMode.externalApplication);
      }
    }
  }

  Future<void> checkUpdate() async {
    try {
      final data = await AppVersionUpdate.checkForUpdates(
        appleId: DotEnvManager().appstoreId,
        playStoreId: DotEnvManager().googleplayId,
      );
      if (!mounted) return;

      if (data.canUpdate == true) {
        FlutterNativeSplash.remove();
        await customConfirmDialog(
          context: context,
          title: localizationManager.generalUpdateAvailable,
          content: localizationManager.generalUpdateAvailableContent,
          onConfirmTap: () async {
            // 다이얼로그 먼저 닫고(겹침 방지) -> 스토어 외부앱으로 열기
            Navigator.of(context, rootNavigator: true).pop();
            await _openStore(
              iosHttpsUrl: data.storeUrl!,                       // AppVersionUpdate가 준 https 링크
              androidPkgId: DotEnvManager().googleplayId,
            );
            // 앱 강제종료 금지: 사용자가 복귀할 수 있게 둠
          },
          onCancelTap: () {
            // 강제 종료 금지. 홈으로 또는 로그인으로.
            Navigator.of(context, rootNavigator: true).pop();
            if (mounted) NavigatorKeyManager().pushNamedAndRemoveUntil(RouteNames.signIn);
          },
        );
      } else {
        NavigatorKeyManager().pushNamedAndRemoveUntil(RouteNames.signIn);
      }
    } catch (e) {
      // 실패 시 안전하게 진행
      if (!mounted) return;
      NavigatorKeyManager().pushNamedAndRemoveUntil(RouteNames.signIn);
    }
  }
}
