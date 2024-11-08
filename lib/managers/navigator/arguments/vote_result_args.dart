import '../../../data/models/vote_model.dart';

class VoteResultArguments {
  VoteResultArguments({
    required this.voteModel,
    required this.authorization,
  });

  final VoteModel voteModel;
  final String authorization;
}
