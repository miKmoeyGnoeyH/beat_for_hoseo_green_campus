import 'package:beat_flutter/components/global/widgets/appbars/custom_empty_appbar.dart';
import 'package:beat_flutter/components/global/widgets/custom_circular_progress_indicator.dart';
import 'package:beat_flutter/components/global/widgets/custom_scaffold.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/oss_licenses.dart';
import 'package:flutter/material.dart';

import 'misc_oss_license_single.dart';

class OSSLicenses extends StatefulWidget {
  const OSSLicenses({super.key});

  @override
  State<OSSLicenses> createState() => _OSSLicensesState();
}

class _OSSLicensesState extends State<OSSLicenses> {
  static Future<List<Package>> loadLicenses() async {
    return allDependencies.toList();
  }

  static final licenses = loadLicenses();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isScrollable: false,
      appBar: const CustomEmptyAppBar(),
      body: FutureBuilder(
        future: licenses,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                final package = snapshot.data![index];
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: context.appColors.borderColor,
                        width: 0.5,
                      )
                    )
                  ),
                  child: ListTile(
                    title: Text('${package.name} ${package.version}'),
                    subtitle: package.description.isNotEmpty
                        ? Text(package.description)
                        : null,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            MiscOssLicenseSingle(package: package),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const CustomCircularProgressIndicator();
          }
        },
      ),
    );
  }
}
