import 'package:BEAT/components/global/widgets/custom_rounded_bordered_container.dart';
import 'package:BEAT/components/global/widgets/texts/custom_body_large.dart';
import 'package:BEAT/components/global/widgets/texts/custom_label_large.dart';
import 'package:BEAT/components/global/widgets/texts/custom_subtitle_large.dart';
import 'package:BEAT/controller/home/events_controller.dart';
import 'package:BEAT/data/models/event_model.dart';
import 'package:BEAT/extensions/buildcontext_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controller/user_bloc.dart';
import '../global/widgets/custom_scaffold.dart';
import 'widgets/home_appbar.dart';
import 'widgets/neuroes_in_hand_card.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserBloc userBloc = context.read<UserBloc>();

    return BlocProvider<QuestsController>(
      create: (context) => QuestsController(),
      child: CustomScaffold(
        appBar: HomeAppbar(userBloc: userBloc),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: Column(
            children: [
              NeuroesInHandCard(userBloc: userBloc),
              BlocBuilder<QuestsController, QuestsState>(
                  builder: (context, state) {
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.quests.length,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: CustomRoundedBorderedContainer(
                          color: context.appColors.background,
                          height: context.height * 0.133,
                          borderWidth: 0.3,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 6,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomLabelLarge(
                                        text:
                                            'Quest ${(index + 1).toString().padLeft(2, '0')}',
                                        textColor: context.appColors.primary,
                                      ),
                                      CustomSubtitleLarge(
                                          text: state.quests[index].eventName),
                                      CustomBodyLarge(
                                          text: state
                                              .quests[index].descriptionShort),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Flexible(
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/beat_coin.png',
                                          width: 25,
                                        ),
                                        const SizedBox(height: 5),
                                        CustomSubtitleLarge(
                                          text:
                                              state.quests[index].neuro.toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  const HomeScreen({super.key});
}
