
import 'package:BEAT/controller/vote/vote_detail_controller.dart';
import 'package:BEAT/managers/navigator/arguments/vote_result_args.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/history/neuro_history_screen.dart';
import '../../components/home/home_screen.dart';
import '../../components/quest_detail/quest_detail_screen.dart';
import '../../components/quiz_detail/quiz_detail_screen.dart';
import '../../components/register_affiliation/register_affiliation_screen.dart';
import '../../components/register_college/register_college_screen.dart';
import '../../components/register_department/register_department_screen.dart';
import '../../components/register_fill_inform/register_fill_inform_screen.dart';
import '../../components/register_org_detail/register_org_detail_screen.dart';
import '../../components/register_organization/register_organization_screen.dart';
import '../../components/register_sign/register_sign_screen.dart';
import '../../components/screen_holder/screen_holder.dart';
import '../../components/settings/settings_screen.dart';
import '../../components/sign_in/sign_in_screen.dart';
import '../../components/vote_result/vote_result_screen.dart';
import '../../controller/home/controllers/data_controller.dart';
import '../../controller/neuro_history/controllers/neuro_history_controller.dart';
import '../../controller/register/register_college_controller.dart';
import '../../controller/register/register_department_controller.dart';
import '../../controller/register/register_organization_controller.dart';
import '../../controller/register_fill_inform/register_nickname_controller.dart';
import '../../controller/register_fill_inform/register_sid_controller.dart';
import '../../controller/vote/vote_result_controller.dart';
import '../../data/models/data_models.dart';
import '../../data/models/vote_model.dart';

part 'route_names.dart';

abstract class Routes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.screenHolder:
        return MaterialPageRoute(
          builder: (context) => const ScreenHolder(),
        );

      case (RouteNames.neuroHistory):
        {
          final String authorization = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => NeuroHistoryController(authorization),
              child: const NeuroHistoryScreen(),
            ),
          );
        }

      case RouteNames.questDetail:
        {
          final QuestModel questModel = settings.arguments as QuestModel;
          return MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => DataDetailModelController(questModel),
              child: const QuestDetailScreen(),
            ),
          );
        }

      case RouteNames.quizDetail:
        {
          final QuizModel arg = settings.arguments as QuizModel;
          return MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => DataDetailModelController(arg),
              child: const QuizDetailScreen(),
            ),
          );
        }

        case RouteNames.voteResult:
        {
          final VoteResultArguments voteResultArguments =
              settings.arguments as VoteResultArguments;
          return MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => VoteResultController(voteResultArguments.voteModel, voteResultArguments.authorization),
              child: const VoteResultScreen(),
            ),
          );
        }

      case RouteNames.voteDetail:
        {
          final VoteModel voteModel = settings.arguments as VoteModel;
          return MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => VoteDetailController(voteModel),
              child: const VoteResultScreen(),
            ),
          );
        }

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
