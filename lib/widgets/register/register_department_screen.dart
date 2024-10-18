import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:BEAT/managers/navigator/navigator_key_manager.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme/texts/custom_texts.dart';
import '../global/custom_appbar.dart';
import '../global/custom_scaffold.dart';

class RegisterDepartmentScreen extends StatefulWidget {
  const RegisterDepartmentScreen({super.key});

  @override
  State<RegisterDepartmentScreen> createState() =>
      _RegisterDepartmentScreenState();
}

// TODO: CollegeBloc의 상태를 구독, DepartmentBloc의 상태를 갱신
// CollegeBloc의 상태에 따라 departments 변수를 초기화
class _RegisterDepartmentScreenState extends State<RegisterDepartmentScreen> {
  final Map<String, String> args = NavigatorKeyManager().arguments as Map<String, String>;
  late final List<String> _departsments;
  late String _department;

  @override
  void initState() {
    _departsments = 'departments'.tr(gender: args['college']).split(', ');
    _department = _departsments[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      top: false,
      isScrollable: false,
      appBar: CustomAppBar(
        title: Text(
          context.tr('department'),
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
            childCount: _departsments.length,
            onSelectedItemChanged: (index) => setState(() {
              _department = _departsments[index];
            }),
            itemBuilder: (context, index) => Center(
              child: AutoSizeText(
                maxLines: 1,
                _departsments[index],
                style: CustomTexts.displayMedium
                    .copyWith(color: context.appColors.onBackground),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          args.putIfAbsent('department', () => _department);
        },
        child: BottomAppBar(
          height: context.width * 0.13,
          color: context.appColors.primary,
          child: Center(
            child: AutoSizeText(
              maxLines: 1,
              context.tr('continue_with', args: [_department]),
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
