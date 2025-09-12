import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoManager {
  static final PackageInfoManager instance = PackageInfoManager();

  init() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

  String get appName => packageInfo.appName;
  String get packageName => packageInfo.packageName;
  String get version => packageInfo.version;
  String get buildNumber => packageInfo.buildNumber;

  late final PackageInfo packageInfo;
}