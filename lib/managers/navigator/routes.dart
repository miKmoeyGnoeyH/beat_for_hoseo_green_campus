import 'package:BEAT/widgets/register/register_affiliation_screen.dart';
import 'package:flutter/material.dart';

import '../../widgets/home/home_screen.dart';
import '../../widgets/register/register_department_screen.dart';
import '../../widgets/register/register_fill_inform_screen.dart';
import '../../widgets/register/register_org_detail_screen.dart';
import '../../widgets/register/register_organization_screen.dart';
import '../../widgets/register/register_college_screen.dart';
import '../../widgets/register/register_sign_screen.dart';
import '../../widgets/settings/settings_screen.dart';
import '../../widgets/sign_in/sign_in_screen.dart';

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
  static Map<String, Widget Function(BuildContext)> routes = {
    RouteNames.home: (context) => HomeScreen(),
    RouteNames.signIn: (context) => SignInScreen(),
    RouteNames.registerOrganization: (context) => const RegisterOrganizationScreen(),
    RouteNames.registerCollege: (context) => const RegisterCollegeScreen(),
    RouteNames.registerDepartment: (context) => const RegisterDepartmentScreen(),
    RouteNames.registerAffiliation: (context) => const RegisterAffiliationScreen(),
    RouteNames.registerOrgDetail: (context) => const RegisterOrgDetailScreen(),
    RouteNames.registerFillInform: (context) => const RegisterFillInformScreen(),
    RouteNames.registerSign: (context) => const RegisterSignScreen(),
    RouteNames.settings: (context) => SettingsScreen(),
  };
}