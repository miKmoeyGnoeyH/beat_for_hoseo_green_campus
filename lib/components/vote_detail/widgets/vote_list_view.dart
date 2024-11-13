import 'package:flutter/material.dart';

import '../../../data/models/data_models.dart';
import 'vote_event_list_card.dart';

class VoteListView extends StatelessWidget {
  const VoteListView({
    required this.voteModel,
    required this.voteDetailModel,
    required this.select,
    required this.toEventDetailPage,
    required this.isSelected,
    required this.isInChoiceListFormList,
    required this.getVotedNeuro,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return VoteEventListCard(
          onTap: () => voteModel.bettingStatus == '진행중'
              ? isInChoiceListFormList(
                      voteDetailModel.bettingEventList[index].eventId)
                  ? () {}
                  : select(
                      voteDetailModel.bettingEventList[index].eventId,
                      voteDetailModel.bettingEventList[index].eventName,
                    )
              : toEventDetailPage(voteDetailModel.bettingEventList[index]),
          onLongPress: () => voteModel.bettingStatus == '진행중'
              ? toEventDetailPage(voteDetailModel.bettingEventList[index])
              : {},
          isSelected: isSelected(
            voteDetailModel.bettingEventList[index].eventId,
          ),
          votedNeuro:
              getVotedNeuro(voteDetailModel.bettingEventList[index].eventId) ??
                  0,
          voteDetailModel: voteDetailModel,
          index: index,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemCount: voteDetailModel.bettingEventList.length,
    );
  }

  final VoteModel voteModel;
  final VoteDetailModel voteDetailModel;
  final Function(int, String) select;
  final Function(QuestModel) toEventDetailPage;
  final Function(int) isSelected;
  final Function(int) isInChoiceListFormList;
  final Function(int) getVotedNeuro;
}
