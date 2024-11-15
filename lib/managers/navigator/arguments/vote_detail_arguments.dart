
import '../../../controller/vote/controllers/vote_list_controller.dart';
import '../../../data/models/data_models.dart';

class VoteDetailArguments {
  VoteDetailArguments(this.voteModel, this.choiceListFormList, this.voteListController);

  final VoteModel voteModel;
  final List<ChoiceVoteModel> choiceListFormList;
  final VoteListController voteListController;
}