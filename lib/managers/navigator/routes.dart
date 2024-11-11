import 'package:BEAT/controller/home/controllers/quiz_list_controller.dart';
import 'package:BEAT/controller/home/controllers/survey_list_controller.dart';
import 'package:BEAT/controller/rank/rank_controller.dart';
import 'package:BEAT/controller/vote/vote_detail_controller.dart';
import 'package:BEAT/managers/navigator/arguments/register_arguments.dart';
import 'package:BEAT/managers/navigator/arguments/register_sign_arguments.dart';
import 'package:BEAT/managers/navigator/arguments/vote_result_args.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/history/neuro_history_screen.dart';
import '../../components/home/home_screen.dart';
import '../../components/quest_detail/quest_detail_screen.dart';
import '../../components/quiz_detail/quiz_detail_screen.dart';
import '../../components/rank/ranking_screen.dart';
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
import '../../controller/home/controllers/quest_list_controller.dart';
import '../../controller/neuro_history/controllers/neuro_history_controller.dart';
import '../../controller/register_fill_inform/register_nickname_controller.dart';
import '../../controller/register_fill_inform/register_sid_controller.dart';
import '../../controller/vote/vote_result_controller.dart';
import '../../data/models/data_models.dart';

part 'route_names.dart';

abstract class Routes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.screenHolder:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(providers: [
            BlocProvider(create: (context) => QuestListController()),
            BlocProvider(create: (context) => QuizListController()),
            BlocProvider(create: (context) => SurveyListController()),
          ], child: const ScreenHolder()),
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
              create: (context) => VoteResultController(
                  voteResultArguments.voteModel,
                  voteResultArguments.authorization),
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

      case RouteNames.ranking:
        {
          return MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => RankController(),
              child: const RankingScreen(),
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
            return RegisterOrganizationScreen();
          },
        );

      case RouteNames.registerCollege:
        {
          final RegisterArguments arguments =
              settings.arguments as RegisterArguments;
          return MaterialPageRoute(
            builder: (context) {
              return RegisterCollegeScreen(arguments);
            },
          );
        }

      case RouteNames.registerDepartment:
        {
          final RegisterArguments arguments =
              settings.arguments as RegisterArguments;

          return MaterialPageRoute(
            builder: (context) {
              return RegisterDepartmentScreen(arguments);
            },
          );
        }

      case RouteNames.registerAffiliation:
        {
          final RegisterArguments arguments =
              settings.arguments as RegisterArguments;
          return MaterialPageRoute(
            builder: (context) => RegisterAffiliationScreen(arguments),
          );
        }

      case RouteNames.registerOrgDetail:
        {
          final RegisterArguments arguments =
              settings.arguments as RegisterArguments;
          return MaterialPageRoute(
            builder: (context) => RegisterOrgDetailScreen(arguments),
          );
        }

      case RouteNames.registerFillInform:
        {
          final RegisterArguments arguments =
              settings.arguments as RegisterArguments;
          return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => RegisterSidController()),
                BlocProvider(create: (context) => RegisterNicknameController()),
              ],
              child: RegisterFillInformScreen(arguments),
            ),
          );
        }

      case RouteNames.registerSign:
        {
          final RegisterSignArguments arguments =
              settings.arguments as RegisterSignArguments;
          return MaterialPageRoute(
            builder: (context) =>
                RegisterSignScreen(arguments.registerSignController),
          );
        }

      case RouteNames.settings:
        return MaterialPageRoute(builder: (context) => SettingsScreen());

      default:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
    }
  }
}
