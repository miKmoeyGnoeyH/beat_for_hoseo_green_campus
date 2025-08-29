import 'package:beat_flutter/controller/home/controllers/quest_list_controller.dart';
import 'package:beat_flutter/controller/pedometer/pedometer_controller.dart';
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../controller/home/controllers/quiz_list_controller.dart';
import '../../controller/home/controllers/survey_list_controller.dart';
import '../../controller/home/events/data_events.dart';
import '../../controller/user_controller.dart';
import '../home/home_screen.dart';
import '../qr/qr_screen.dart';
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
    Future<void> onPullDown() {
      final UserController userController = context.read<UserController>();
      userController.add(GetMyNeuro());
      context.read<QuestListController>().add(DataListRequest());
      // context.read<QuizListController>().add(DataListRequest());
      context.read<SurveyListController>().add(DataListRequest());
      Get.find<PedometerController>().getWalkHitory();
      // context.read<VoteListController>().add(VoteListRequest(userController.state.authorization));
      return Future.delayed(const Duration(seconds: 0));
    }

    return Scaffold(
      body: Container(
        color: context.appColors.surface,
        child: SafeArea(
          top: false,
          bottom: false,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => const [
              HomeAppbar(),
            ],
            body: RefreshIndicator(
              color: context.appColors.primary,
              onRefresh: onPullDown,
              notificationPredicate: (n) => true,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                children: [
                  _screens[_selectedIndex],
                ],
              ),
            ),
          ),
        ),
      ),
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
    HomeScreen(),
    // const VoteScreen()
  ];
  int _selectedIndex = 1;
}
