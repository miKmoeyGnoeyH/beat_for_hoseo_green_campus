
import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../global/widgets/appbars/custom_empty_appbar.dart';
import '../global/widgets/custom_scaffold.dart';
import '../global/widgets/texts/custom_body_large.dart';
import '../global/widgets/texts/custom_display_medium.dart';
import '../home/widgets/home_contents_tab_button.dart';
import 'widgets/info_earning_card.dart';
import 'widgets/info_images.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomEmptyAppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          CustomDisplayMedium(
            text: context.tr('info'),
            textColor: context.appColors.defaultTextColor,
          ),
          CustomBodyLarge(
            text: context.tr('info_desc'),
          ),
          const SizedBox(height: 16),
          InfoImages(
            activeIndex: activeIndex,
            onPageChanged: onPageChanged,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              HomeContentsTabButton(
                onTap: () {
                  setState(() {
                    selectedIndex = 0;
                  });
                },
                title: context.tr('acquisition'),
                textColor: selectedIndex == 0
                    ? context.appColors.primary
                    : context.appColors.onBackground,
              ),
              HomeContentsTabButton(
                onTap: () {
                  setState(() {
                    selectedIndex = 1;
                  });
                },
                title: context.tr('usage'),
                textColor: selectedIndex == 1
                    ? context.appColors.primary
                    : context.appColors.onBackground,
              ),
            ],
          ),
          const SizedBox(height: 16),
          InfoListCard(selectedIndex),
        ],
      ),
    );
  }

  void onPageChanged(int index, CarouselPageChangedReason reason) {
    setState(() {
      activeIndex = index;
    });
  }

  void setSelectieIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  int activeIndex = 0;
  int selectedIndex = 0;
}
