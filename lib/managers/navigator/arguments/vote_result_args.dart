import '../../../data/models/data_models.dart';

class VoteResultArguments {
  VoteResultArguments({
    required this.voteModel,
    required this.authorization,
  });

  final VoteModel voteModel;
  final String authorization;
}
