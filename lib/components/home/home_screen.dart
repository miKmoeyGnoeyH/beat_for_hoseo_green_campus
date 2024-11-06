import 'package:BEAT/components/home/widgets/home_contents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controller/user_bloc.dart';
import 'widgets/neuroes_in_hand_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserBloc userBloc = context.read<UserBloc>();

    return Center(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          NeuroesInHandCard(userBloc: userBloc),
          const SizedBox(height: 20,),
          const HomeContents(),
          const SizedBox(height: 20,)
        ],
      ),
    );
  }
}