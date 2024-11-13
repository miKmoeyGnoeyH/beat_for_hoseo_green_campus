import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';

class HomeBottomNavigationBar extends StatelessWidget {
  const HomeBottomNavigationBar({
    super.key,
    required int selectedIndex,
    this.onTap,
  }) : currentIndex = selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: context.appColors.onBackground.withOpacity(0.1),
            width: 0.1,
          ),
        ),
      ),
      child: BottomNavigationBar(
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
      ),
    );
  }

  final Function(int)? onTap;
  final int currentIndex;
}