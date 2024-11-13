import 'package:BEAT/data/models/data_models.dart';

sealed class VoteListState {}

final class VoteListInitial extends VoteListState {
  VoteListInitial();
}

final class VoteListLoading extends VoteListState {
  VoteListLoading();
}

final class VoteListLoadingError extends VoteListState {
  VoteListLoadingError();
}

final class VoteListLoadingSuccess extends VoteListState {
  VoteListLoadingSuccess(this.voteList);
  final VoteList voteList;
}