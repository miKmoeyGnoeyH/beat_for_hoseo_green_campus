import 'dart:developer';
import 'dart:io';

import 'package:app_version_update/app_version_update.dart';
import 'package:beat_flutter/app.dart';
import 'package:beat_flutter/components/global/methods/custom_show_dialog.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/dotenv/dotenv_manager.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:beat_flutter/managers/navigator/navigator_key_manager.dart';
import 'package:beat_flutter/managers/navigator/routes.dart';
import 'package:beat_flutter/managers/permission/permission_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:url_launcher/url_launcher.dart';

class InitPage extends StatefulWidget {
  InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> with WidgetsBindingObserver {
  final LocalizationManager localizationManager = LocalizationManager();

  @override
  void initState() {
    super.initState();
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

  Future<void> _openStore({
    required String iosHttpsUrl,
    required String androidPkgId,
  }) async {
    if (Platform.isIOS) {
      final itms = Uri.parse(iosHttpsUrl.replaceFirst('https://', 'itms-apps://'));
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
        await customShowDialog(
          context: context,
          title: localizationManager.generalUpdateAvailable,
          content: localizationManager.generalUpdateAvailableContent,
          onTap: () async {
            Navigator.of(context, rootNavigator: true).pop();
            await _openStore(
              iosHttpsUrl: data.storeUrl!,
              androidPkgId: DotEnvManager().googleplayId,
            );
            checkUpdate();
          },
        );
      } else {
        NavigatorKeyManager().pushNamedAndRemoveUntil(RouteNames.signIn);
      }
    } catch (e) {
      if (!mounted) return;
      NavigatorKeyManager().pushNamedAndRemoveUntil(RouteNames.signIn);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        checkUpdate();
        App.isForeground = true;
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        App.isForeground = false;
        break;
      default:
        break;
    }
  }
}
