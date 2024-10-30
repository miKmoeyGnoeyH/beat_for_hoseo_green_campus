import 'package:BEAT/controller/register/register_college_controller.dart';
import 'package:BEAT/controller/register/register_department_controller.dart';
import 'package:BEAT/controller/register/register_organization_controller.dart';
import 'package:BEAT/controller/register_fill_inform/register_nickname_controller.dart';
import 'package:BEAT/controller/register_fill_inform/register_sid_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/home/home_screen.dart';
import '../../components/register_affiliation/register_affiliation_screen.dart';
import '../../components/register_college/register_college_screen.dart';
import '../../components/register_department/register_department_screen.dart';
import '../../components/register_fill_inform/register_fill_inform_screen.dart';
import '../../components/register_org_detail/register_org_detail_screen.dart';
import '../../components/register_organization/register_organization_screen.dart';
import '../../components/register_sign/register_sign_screen.dart';
import '../../components/settings/settings_screen.dart';
import '../../components/sign_in/sign_in_screen.dart';

abstract class RouteNames {
  static const String home = '/home';
  static const String signIn = '/signIn';
  static const String registerOrganization = '/register_organization';
  static const String registerCollege = '/register_college';
  static const String registerDepartment = '/register_department';
  static const String registerAffiliation = '/register_affiliation';
  static const String registerOrgDetail = '/register_org_detail';
  static const String registerFillInform = '/register_fill_inform';
  static const String registerSign = '/register_sign';
  static const String settings = '/settings';
}

abstract class Routes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {

      case RouteNames.home:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );

      case RouteNames.signIn:
        return MaterialPageRoute(
          builder: (context) => SignInScreen(),
        );

      case RouteNames.registerOrganization:
        return MaterialPageRoute(
          builder: (context) {
            return BlocProvider(
              create: (context) => RegisterOrganizationController(),
              child: const RegisterOrganizationScreen(),
            );
          },
        );

      case RouteNames.registerCollege:
        {
          return MaterialPageRoute(
            builder: (context) {
              return BlocProvider(
                create: (context) => RegisterCollegeController(),
                child: const RegisterCollegeScreen(),
              );
            },
          );
        }

      case RouteNames.registerDepartment:
        {
          return MaterialPageRoute(
            builder: (context) {
              return BlocProvider(
                create: (context) => RegisterDepartmentController.fromOthers(),
                child: const RegisterDepartmentScreen(),
              );
            },
          );
        }

      case RouteNames.registerAffiliation:
        {
          return MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) =>
                  RegisterDepartmentController.fromAffiliation(),
              child: const RegisterAffiliationScreen(),
            ),
          );
        }

      case RouteNames.registerOrgDetail:
        {
          return MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => RegisterDepartmentController.fromOthers(),
              child: const RegisterOrgDetailScreen(),
            ),
          );
        }

      case RouteNames.registerFillInform:
        {
          return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [
                // BlocProvider.value(
                //   value: organizationContext!
                //       .read<RegisterOrganizationController>(),
                // ),
                // BlocProvider.value(
                //   value: BlocProvider.of<RegisterCollegeController>(
                //       collegeContext!),
                // ),
                // BlocProvider.value(
                //   value: BlocProvider.of<RegisterDepartmentController>(
                //       departmentContext!),
                // ),
                BlocProvider(create: (context) => RegisterSidController()),
                BlocProvider(create: (context) => RegisterNicknameController()),
              ],
              child: const RegisterFillInformScreen(),
            ),
          );
        }

      case RouteNames.registerSign:
        return MaterialPageRoute(
            builder: (context) => const RegisterSignScreen());

      case RouteNames.settings:
        return MaterialPageRoute(builder: (context) => SettingsScreen());

      default:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
    }
  }
}
