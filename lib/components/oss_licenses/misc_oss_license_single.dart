import 'package:beat_flutter/components/global/widgets/appbars/custom_appbar.dart';
import 'package:beat_flutter/components/global/widgets/custom_scaffold.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/navigator/navigator_key_manager.dart';
import 'package:beat_flutter/oss_licenses.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MiscOssLicenseSingle extends StatelessWidget {
  final Package package;

  const MiscOssLicenseSingle({super.key, required this.package});

  String _bodyText() {
    return package.license!.split('\n').map((line) {
      if (line.startsWith('//')) line = line.substring(2);
      line = line.trim();
      return line;
    }).join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        title: Text('${package.name} ${package.version}'),
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: GestureDetector(
            onTap: () => NavigatorKeyManager().pop(),
            child: Icon(
              Icons.arrow_back_ios,
              color: context.appColors.primary,
              size: 24,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          if (package.description.isNotEmpty)
            Padding(
                padding:
                    const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
                child: Text(package.description,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold))),
          if (package.homepage != null)
            Padding(
                padding:
                    const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
                child: InkWell(
                  child: Text(package.homepage!,
                      style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline)),
                  onTap: () => launchUrlString(package.homepage!),
                )),
          if (package.description.isNotEmpty || package.homepage != null)
            const Divider(),
          Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
            child: Text(_bodyText(),
                style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
