
import 'package:beat_flutter/extensions/buildcontext_extension.dart';
import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:flutter/material.dart';

class HomeBottomNavigationBar extends StatelessWidget {
  HomeBottomNavigationBar({
    super.key,
    required int selectedIndex,
    this.onTap,
  }) : currentIndex = selectedIndex;

  final LocalizationManager localizationManager = LocalizationManager();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: context.appColors.onBackground.withValues(alpha: 0.9),
            width: 0.03,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: context.appColors.primary,
        unselectedItemColor: context.appColors.onBackground,
        backgroundColor: context.appColors.background,
        onTap: onTap,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.qr_code_rounded),
            label: localizationManager.bnbQR,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            label: localizationManager.bnbHome,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outlined),
            label: localizationManager.bnbMyPage,
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.how_to_vote_rounded),
          //   label: 'Vote',
          // ),
        ],
      ),
    );
  }

  final Function(int)? onTap;
  final int currentIndex;
}