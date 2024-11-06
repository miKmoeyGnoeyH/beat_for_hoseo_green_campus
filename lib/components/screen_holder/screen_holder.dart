import 'package:BEAT/components/global/widgets/custom_scaffold.dart';
import 'package:BEAT/components/home/home_screen.dart';
import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controller/user_bloc.dart';
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
    final UserBloc userBloc = context.read<UserBloc>();
    return CustomScaffold(
      appBar: HomeAppbar(userBloc: userBloc),
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
    const SizedBox(),
    const HomeScreen(),
    const SizedBox()
  ];
  int _selectedIndex = 1;
}