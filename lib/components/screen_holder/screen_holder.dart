
import 'package:BEAT/components/global/widgets/custom_scaffold.dart';
import 'package:BEAT/components/home/home_screen.dart';
import 'package:BEAT/components/qr/qr_screen.dart';
import 'package:BEAT/components/vote/vote_screen.dart';
import 'package:BEAT/controller/home/controllers/quest_list_controller.dart';
import 'package:BEAT/controller/home/controllers/quiz_list_controller.dart';
import 'package:BEAT/controller/home/controllers/survey_list_controller.dart';
import 'package:BEAT/controller/home/events/data_events.dart';
import 'package:BEAT/controller/vote/event/vote_list_event.dart';
import 'package:BEAT/controller/vote/controllers/vote_list_controller.dart';
import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controller/user_controller.dart';
import 'widgets/home_appbar.dart';
import 'widgets/home_bottom_navigation_bar.dart';

class ScreenHolder extends StatefulWidget {
  const ScreenHolder({super.key});

  @override
  State<ScreenHolder> createState() => _ScreenHolderState();
}

class _ScreenHolderState extends State<ScreenHolder> {
  @override
  Widget build(BuildContext context) {
    final UserController userController = context.read<UserController>();
    final QuestListController questListController =
        context.read<QuestListController>();
    final QuizListController quizListController =
        context.read<QuizListController>();
    final SurveyListController surveyListController =
        context.read<SurveyListController>();
    final VoteListController voteController = context.read<VoteListController>();

    Future<void> onPullDown() {
      userController.add(GetMyNeuro());
      questListController.add(DataListRequest());
      quizListController.add(DataListRequest());
      surveyListController.add(DataListRequest());
      voteController.add(VoteListRequest(userController.state.authorization));
      return Future.delayed(const Duration(seconds: 0));
    }

    return CustomScaffold(
      onPullDown: onPullDown,
      appBar: const HomeAppbar(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: context.appColors.borderColor,
              width: 0.1,
            ),
          ),
        ),
        child: HomeBottomNavigationBar(
          onTap: _setIndex,
          selectedIndex: _selectedIndex,
        ),
      ),
    );
  }

  void _setIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _screens = [
    const QrScreen(),
    const HomeScreen(),
    const VoteScreen()
  ];
  int _selectedIndex = 1;
}
