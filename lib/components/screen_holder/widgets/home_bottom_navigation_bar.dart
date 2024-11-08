import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

class HomeBottomNavigationBar extends StatelessWidget {
  HomeBottomNavigationBar({
    super.key,
    required int selectedIndex,
    this.onTap,
  }) : currentIndex = selectedIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: context.appColors.primary,
      unselectedItemColor: context.appColors.onBackground,
      backgroundColor: context.appColors.background,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.qr_code_rounded),
          label: 'QR',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.how_to_vote_rounded),
          label: 'Vote',
        ),
      ],
    );
  }

  Function(int)? onTap;
  final int currentIndex;
}