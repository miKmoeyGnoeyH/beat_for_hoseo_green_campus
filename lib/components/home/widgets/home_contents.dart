
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'home_contents_tab_button.dart';
import 'quest_list/quest_list.dart';
import 'quiz_list/quiz_list.dart';
import 'survey_list/survey_list.dart';

class HomeContentsItem {
  HomeContentsItem(this.title, this.content);

  final String title;
  final Widget content;
}

class HomeContents extends StatefulWidget {
  const HomeContents({super.key});

  @override
  State<HomeContents> createState() => _HomeContentsState();
}

class _HomeContentsState extends State<HomeContents> {
  final List<HomeContentsItem> _contents = [
    HomeContentsItem('quest'.tr(), const HomeQuestList()),
    HomeContentsItem('quiz'.tr(), const HomeQuizList()),
    HomeContentsItem('survey'.tr(), const HomeSurveyList()),
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            for (int i = 0; i < _contents.length; i++)
              HomeContentsTabButton(
                  onTap: () {
                    setState(() {
                      _currentIndex = i;
                    });
                  },
                  title: _contents[i].title,
                  textColor: i == _currentIndex
                      ? context.appColors.primary
                      : context.appColors.onBackground),
          ],
        ),
        _contents[_currentIndex].content,
      ],
    );
  }
}