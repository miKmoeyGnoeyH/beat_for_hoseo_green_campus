import 'dart:developer';

import 'package:beat_flutter/components/forgot_password/reset_password.dart';
import 'package:beat_flutter/components/notice_detail/notice_detail.dart';
import 'package:beat_flutter/components/oss_licenses/oss_licenses.dart';
import 'package:beat_flutter/components/survey_detail/survey_detail.dart';
import 'package:beat_flutter/controller/home/controllers/quest_list_controller.dart';
import 'package:beat_flutter/controller/home/controllers/survey_detail_controller.dart';
import 'package:beat_flutter/controller/location/location_controller.dart';
import 'package:beat_flutter/controller/pedometer/pedometer_controller.dart';
import 'package:beat_flutter/controller/rank/rank_controller_test.dart';
import 'package:beat_flutter/controller/screen_holder/page_index_controller.dart';
import 'package:beat_flutter/controller/user_controller.dart';
import 'package:beat_flutter/data/provider/rank_list_provider.dart';
import 'package:beat_flutter/data/repository/rank_list_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../components/history/neuro_history_screen.dart';
import '../../components/info/info_screen.dart';
import '../../components/notifications/notifications_screen.dart';
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
import '../../components/vote_detail/vote_detail_screen.dart';
import '../../components/vote_result/vote_result_screen.dart';
import '../../components/withdrawal/withdrawal_screen.dart';
import '../../controller/home/controllers/data_controller.dart';
import '../../controller/home/controllers/quiz_list_controller.dart';
import '../../controller/home/controllers/survey_list_controller.dart';
import '../../controller/info/controller/info_image_controller.dart';
import '../../controller/info/controller/info_list_controller.dart';
import '../../controller/neuro_history/controllers/neuro_history_controller.dart';
import '../../controller/notification/notification_controller.dart';
import '../../controller/rank/rank_controller.dart';
import '../../controller/register_fill_inform/register_nickname_controller.dart';
import '../../controller/register_fill_inform/register_sid_controller.dart';
import '../../controller/vote/controllers/vote_detail_controller.dart';
import '../../controller/vote/controllers/vote_result_controller.dart';
import '../../data/models/data_models.dart';
import 'arguments/register_arguments.dart';
import 'arguments/register_sign_arguments.dart';
import 'arguments/screen_holder_arguments.dart';
import 'arguments/vote_detail_arguments.dart';
import 'arguments/vote_result_args.dart';

part 'route_names.dart';

abstract class Routes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.info:
        {
          return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => InfoImageController()),
                BlocProvider(create: (context) => InfoListController()),
              ],
              child: const InfoScreen(),
            ),
          );
        }

      case RouteNames.neuroHistory:
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

      case RouteNames.ranking:
        {
          final String authorization = settings.arguments as String;

          Get.put(RankControllerTest(
              RankListRepository(RankListProvider()), authorization));

          return MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => RankController(),
              child: const RankingScreen(),
            ),
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

      case RouteNames.registerFillInform:
        {
          final RegisterArguments arguments =
              settings.arguments as RegisterArguments;
          return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => RegisterIDController()),
                BlocProvider(create: (context) => RegisterNicknameController()),
              ],
              child: RegisterFillInformScreen(arguments),
            ),
          );
        }

      case RouteNames.registerOrganization:
        return MaterialPageRoute(
          builder: (context) {
            return RegisterOrganizationScreen();
          },
        );

      case RouteNames.registerOrgDetail:
        {
          final RegisterArguments arguments =
              settings.arguments as RegisterArguments;
          return MaterialPageRoute(
            builder: (context) => RegisterOrgDetailScreen(arguments),
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

      case RouteNames.screenHolder:
        {
          final ScreenHolderArguments arguments =
              settings.arguments as ScreenHolderArguments;
          return MaterialPageRoute(
            builder: (context) {
              Get.put(SurveyDetailController());
              Get.put(PageIndexController());

              final UserController userController =
                  context.read<UserController>();

              Get.find<PedometerController>()
                  .setAuthorization(arguments.authorization);
              Get.find<PedometerController>()
                  .setSendToTime(arguments.sendToTime);

              Get.find<PedometerController>().getWalkHitory();
              Get.find<PedometerController>().initializeService();
              Get.find<PedometerController>().startBackgroundService();

              Get.find<LocationController>().setUp();
              // Get.find<LocationController>().checkIsValidArea();
              Get.find<LocationController>().initializeService();
              Get.find<LocationController>().startBackgroundService();

              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                      create: (context) =>
                          QuestListController(arguments.authorization)),
                  BlocProvider(create: (context) => QuizListController()),
                  BlocProvider(create: (context) => SurveyListController()),
                  // BlocProvider(
                  //   create: (context) =>
                  //       VoteListController(arguments.authorization),
                  // ),
                ],
                child: const ScreenHolder(),
              );
            },
          );
        }

      case RouteNames.settings:
        return MaterialPageRoute(builder: (context) => SettingsScreen());

      case RouteNames.signIn:
        return MaterialPageRoute(
          builder: (context) => SignInScreen(),
        );

      case RouteNames.voteDetail:
        {
          final VoteDetailArguments voteDetailArguments =
              settings.arguments as VoteDetailArguments;

          return MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) =>
                  VoteDetailController(voteDetailArguments.voteModel),
              child: VoteDetailScreen(voteDetailArguments),
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

      case RouteNames.withdrawal:
        {
          return MaterialPageRoute(
            builder: (context) => WithdrawalScreen(),
          );
        }

      case RouteNames.notifications:
        {
          return MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => NotificationsController(),
              child: NotificationsScreen(),
            ),
          );
        }

      case RouteNames.noticeDetail:
        {
          final NotificationModel notificationModel = settings.arguments as NotificationModel;
          return MaterialPageRoute(
            builder: (context) => NoticeDetail(notificationModel: notificationModel,),
          );
        }

      case RouteNames.ossLicenses:
        {
          return MaterialPageRoute(
            builder: (context) => const OSSLicenses(),
          );
        }

      case RouteNames.resetPassword:
        {
          return MaterialPageRoute(
            builder: (context) => const ResetPassword(),
          );
        }

      case RouteNames.surveyDetail:
        {
          return MaterialPageRoute(
            builder: (context) => SurveyDetail(),
          );
        }

      default:
        {
          log("Routes: default case");
          return MaterialPageRoute(builder: (context) => SignInScreen());
        }
    }
  }
}
