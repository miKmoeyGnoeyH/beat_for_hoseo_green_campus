import 'dart:developer';

import 'package:Beat/components/vote_detail/widgets/vote_desc.dart';
import 'package:Beat/extensions/buildcontext_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../controller/home/events/data_events.dart';
import '../../controller/user_controller.dart';
import '../../controller/vote/controllers/vote_detail_controller.dart';
import '../../controller/vote/controllers/vote_list_controller.dart';
import '../../controller/vote/event/vote_list_event.dart';
import '../../data/models/data_models.dart';
import '../../data/states/data_state.dart';
import '../../managers/navigator/arguments/vote_detail_arguments.dart';
import '../../managers/navigator/navigator_key_manager.dart';
import '../../managers/navigator/routes.dart';
import '../global/methods/custom_show_dialog.dart';
import '../global/widgets/appbars/custom_empty_appbar.dart';
import '../global/widgets/buttons/custom_bottom_appbar_button.dart';
import '../global/widgets/buttons/custom_refresh_button.dart';
import '../global/widgets/custom_circular_progress_indicator.dart';
import '../global/widgets/custom_scaffold.dart';
import '../global/widgets/texts/custom_title_large.dart';
import 'widgets/vote_list_view.dart';
import 'widgets/vote_status.dart';
import 'widgets/voted_neuro_select_bottom_sheet.dart';

class VoteDetailScreen extends StatefulWidget {
  const VoteDetailScreen(this.arguments, {super.key});

  final VoteDetailArguments arguments;

  @override
  State<VoteDetailScreen> createState() => _VoteDetailScreenState();
}

class _VoteDetailScreenState extends State<VoteDetailScreen> {
  List<ChoiceVoteModel> get choiceListFormList =>
      widget.arguments.choiceListFormList;

  VoteListController get voteListController =>
      widget.arguments.voteListController;

  VoteModel get voteModel => widget.arguments.voteModel;

  @override
  Widget build(BuildContext context) {
    final UserController userController = context.read<UserController>();
    final VoteDetailController voteDetailController =
        context.read<VoteDetailController>();

    Future<void> onPullDown() {
      voteListController
          .add(VoteListRequest(userController.state.authorization));
      voteDetailController.add(DataDetailRequest());
      return Future.delayed(const Duration(seconds: 0));
    }

    return CustomScaffold(
      onPullDown: onPullDown,
      appBar: const CustomEmptyAppBar(),
      body: BlocBuilder<VoteDetailController, DataDetailModelState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                VoteStatus(voteModel.bettingStatus!),
                const SizedBox(height: 16),
                CustomTitleLarge(text: voteModel.bettingName),
                const SizedBox(height: 5),
                const VoteDesc(),
                const SizedBox(height: 16),
                if (state is DataDetailModelLoadingSuccess)
                  VoteListView(
                    voteModel: voteModel,
                    voteDetailModel: (state.dataModel as VoteDetailModel),
                    select: select,
                    toEventDetailPage: toEventDetailPage,
                    isSelected: isSelected,
                    isInChoiceListFormList: isInChoiceListFormList,
                    getVotedNeuro: getVotedNeuro,
                  )
                else if (state is DataDetailModelLoading)
                  const CustomCircularProgressIndicator()
                else
                  CustomRefreshButton(
                    onTap: () => voteDetailController.add(
                      DataDetailRequest(),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomAppbarButton(
          onTap: voteModel.bettingStatus == '진행중'
              ? selectedEvents.isNotEmpty
                  ? isVoteButtonEnabled
                      ? () async {
                          isVoteButtonEnabled = false;
                          final String requestUrl = dotenv.env['VOTTING_VOTE']!;
                          final String authorization =
                              userController.state.authorization;
                          final int bettingId = voteModel.bettingId!;

                          try {
                            for (int eventId in selectedEvents) {
                              final Map<String, String> body = {
                                'bettingId': bettingId.toString(),
                                'bettingEventId': eventId.toString(),
                                'voteNeuro': selectedEventsVotedNeuro[eventId]
                                    .toString(),
                              };

                              log(body.toString());

                              final http.Response response = await http
                                  .post(
                                    Uri.parse(requestUrl),
                                    headers: {'Authorization': authorization},
                                    body: body,
                                  )
                                  .timeout(const Duration(seconds: 5));

                              log(response.body);

                              if (response.statusCode != 200) {
                                throw Exception(response.body);
                              }
                            }
                            if (context.mounted) {
                              customShowDialog(
                                context: context,
                                title: context.tr('vote_success'),
                                content: context.tr('vote_success_message'),
                              );

                            }
                            userController.add(GetMyNeuro());
                            voteListController
                                .add(VoteListRequest(authorization));
                            voteDetailController.add(DataDetailRequest());
                            selectedEvents.clear();
                            selectedEventsVotedNeuro.clear();
                          } catch (e) {
                            log('vote_detail_screen : ${e.toString()}');
                            if (context.mounted) {
                              customShowDialog(
                                context: context,
                                title: context.tr('vote_failed'),
                                content: context.tr('error_occured'),
                              );
                            }
                          } finally {
                            isVoteButtonEnabled = true;
                          }
                        }
                      : () {}
                  : () {}
              : () {},
          text: voteModel.bettingStatus == '진행중'
              ? selectedEvents.isNotEmpty
                  ? context.tr('vote')
                  : context.tr('select_item_to_vote')
              : context.tr('vote_is_not_in_progress'),
          backgroundColor: voteModel.bettingStatus == '진행중'
              ? selectedEvents.isNotEmpty
                  ? isVoteButtonEnabled
                      ? context.appColors.primary
                      : context.appColors.disabled
                  : context.appColors.disabled
              : context.appColors.disabled),
    );
  }

  void select(int eventId, String eventName) async {
    if (selectedEvents.contains(eventId)) {
      setState(() {
        selectedEvents.remove(eventId);
        selectedEventsVotedNeuro.remove(eventId);
      });
    } else {
      if (selectedEvents.length + choiceListFormList.length >= 2) return;

      final int? votedNeuro = await showModalBottomSheet<int>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) =>
            VoteNeuroSelectBottomSheet(eventName),
      );

      if (votedNeuro != null) {
        setState(() {
          selectedEvents.add(eventId);
          selectedEventsVotedNeuro[eventId] = votedNeuro;
        });
      }
    }
  }

  void toEventDetailPage(QuestModel event) {
    NavigatorKeyManager().pushNamed(RouteNames.questDetail, arguments: event);
  }

  bool isSelected(int eventId) {
    bool isInChoiceListFormList = false;

    if (choiceListFormList.isNotEmpty) {
      for (var element in choiceListFormList) {
        if (element.eventId == eventId) {
          isInChoiceListFormList = true;
          break;
        }
      }
    }

    return selectedEvents.contains(eventId) || isInChoiceListFormList;
  }

  bool isInChoiceListFormList(int eventId) {
    if (choiceListFormList.isNotEmpty) {
      for (var element in choiceListFormList) {
        if (element.eventId == eventId) {
          return true;
        }
      }
    }

    return false;
  }

  int? getVotedNeuro(int eventId) {
    if (choiceListFormList.isNotEmpty) {
      for (var element in choiceListFormList) {
        if (element.eventId == eventId) {
          return element.neuro;
        }
      }
    }

    return selectedEventsVotedNeuro[eventId];
  }

  List<int> selectedEvents = [];

  Map<int, int> selectedEventsVotedNeuro = {};

  bool isVoteButtonEnabled = true;
}
