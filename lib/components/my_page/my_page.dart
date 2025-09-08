import 'package:beat_flutter/components/global/widgets/custom_rounded_bordered_container.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_body_large.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_display_medium.dart';
import 'package:beat_flutter/components/global/widgets/texts/custom_subtitle_large.dart';
import 'package:beat_flutter/controller/user_controller.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:beat_flutter/managers/navigator/navigator_key_manager.dart';
import 'package:beat_flutter/managers/navigator/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyPage extends StatelessWidget {
  MyPage({super.key});

  final LocalizationManager localizationManager = LocalizationManager();

  @override
  Widget build(BuildContext context) {
    final UserController userController = context.read<UserController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomDisplayMedium(text: localizationManager.mpAppbarTitle),
              const SizedBox(height: 10),
              CustomRoundedBorderedContainer(
                width: double.infinity,
                borderWidth: 0.5,
                color: context.appColors.background,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Table(
                    columnWidths: const {
                      0: IntrinsicColumnWidth(),
                      1: FlexColumnWidth(),
                    },
                    children: [
                      buildMyPageTableRow(
                        label: localizationManager.mpCategory,
                        content: getCategory(userController.state.category),
                      ),
                      buildMyPageTableRowSpacing(),
                      buildMyPageTableRow(
                        label: getIDLabel(userController.state.category),
                        content: userController.state.studentId,
                      ),
                      buildMyPageTableRowSpacing(),
                      buildMyPageTableRow(
                        label: localizationManager.mpName,
                        content: userController.state.name,
                      ),
                      buildMyPageTableRowSpacing(),
                      buildMyPageTableRow(
                        label: localizationManager.mpDepartment,
                        content: userController.state.department,
                      ),
                      buildMyPageTableRowSpacing(),
                      buildMyPageTableRow(
                        label: localizationManager.mpEmail,
                        content: userController.state.email,
                      ),
                      buildMyPageTableRowSpacing(),
                      buildMyPageTableRow(
                        label: localizationManager.mpNickname,
                        content: userController.state.nickname,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: onForgotPasswordTap,
            child: CustomBodyLarge(
              text: localizationManager.mpChangePassword,
              // textColor: context.appColors.disabled,
            ),
          ),
        ],
      ),
    );
  }

  void onForgotPasswordTap() {
    // log("forgot password");
    NavigatorKeyManager()
        .pushNamed(RouteNames.resetPassword);
  }

  String getCategory(String category) => switch (category) {
        "student" => localizationManager.mpStudent,
        "employee" => localizationManager.mpEmployee,
        _ => localizationManager.mpOthers,
      };

  String getIDLabel(String category) => switch (category) {
        "student" => localizationManager.mpStudentID,
        "employee" => localizationManager.mpEmployeeID,
        _ => localizationManager.mpID,
      };
}

TableRow buildMyPageTableRow(
    {required String? label, required String? content}) {
  return TableRow(
    children: [
      TableCell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomSubtitleLarge(text: label),
            CustomBodyLarge(text: content),
          ],
        ),
      ),
    ],
  );
}

TableRow buildMyPageTableRowSpacing() {
  return const TableRow(
    children: [
      TableCell(
        child: SizedBox(height: 10),
      ),
    ],
  );
}
