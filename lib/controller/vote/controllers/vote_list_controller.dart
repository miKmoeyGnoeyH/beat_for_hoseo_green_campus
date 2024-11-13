import 'package:BEAT/controller/vote/event/vote_list_event.dart';
import 'package:BEAT/data/states/vote_list_state.dart';
import 'package:bloc/bloc.dart';

import '../../../data/provider/vote_provider.dart';

class VoteListController extends Bloc<VoteListEvent, VoteListState> {
  VoteListController(String authorization) : super(VoteListInitial()) {
    on<VoteListRequest>(_onVoteListRequest);
    add(VoteListRequest(authorization));
  }

  Future<void> _onVoteListRequest(VoteListRequest event, Emitter<VoteListState> emit) async {
    emit(VoteListLoading());

    final VoteListState voteListState = await _voteProvider.fetchVoteList(event.authorization);

    emit(voteListState);
  }

  final VoteProvider _voteProvider = VoteProvider();
}