import 'dart:developer';

import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:BEAT/managers/navigator/navigator_key_manager.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../managers/navigator/routes.dart';
import '../../theme/texts/custom_texts.dart';
import '../global/custom_appbar.dart';
import '../global/custom_scaffold.dart';

class RegisterCollegeScreen extends StatefulWidget {
  const RegisterCollegeScreen({super.key});

  @override
  State<RegisterCollegeScreen> createState() => _RegisterCollegeScreenState();
}

// TODO: CollegeBloc의 상태를 갱신
class _RegisterCollegeScreenState extends State<RegisterCollegeScreen> {
  final Map<String, String> args =
      NavigatorKeyManager().arguments as Map<String, String>;
  late final List<String> _colleges;
  late String _college = 'colleges'.tr().split(', ')[0];

  @override
  void initState() {
    _colleges = 'colleges'.tr().split(', ');
    _college = _colleges[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      top: false,
      isScrollable: false,
      appBar: CustomAppBar(
        title: Text(
          context.tr('college'),
          style: CustomTexts.displaySmall,
        ),
        iconTheme: IconThemeData(
          color: context.appColors.primary,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: CupertinoPicker.builder(
            itemExtent: 50,
            childCount: _colleges.length,
            onSelectedItemChanged: (index) => setState(() {
              _college = _colleges[index];
            }),
            itemBuilder: (context, index) => Center(
              child: Text(
                _colleges[index],
                style: CustomTexts.displayMedium
                    .copyWith(color: context.appColors.onBackground),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          args.putIfAbsent('college', () => _college);

          NavigatorKeyManager().pushNamed(
            RouteNames.registerDepartment,
            arguments: args,
          );
        },
        child: BottomAppBar(
          height: context.width * 0.13,
          color: context.appColors.primary,
          child: Center(
            child: AutoSizeText(
              maxLines: 1,
              context.tr('continue_with', args: [_college]),
              style: CustomTexts.titleLarge.copyWith(
                color: context.appColors.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
