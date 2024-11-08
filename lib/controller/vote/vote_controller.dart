import 'package:BEAT/controller/home/events/data_events.dart';
import 'package:BEAT/data/states/data_list_state.dart';
import 'package:bloc/bloc.dart';

import '../../data/provider/vote_provider.dart';

class VoteController extends Bloc<DataEvent, DataListState> {
  VoteController() : super(DataListInitial()) {
    on<DataListRequest>(_onDataListRequest);
    add(DataListRequest());
  }

  Future<void> _onDataListRequest(DataEvent event, Emitter<DataListState> emit) async {
    emit(DataListLoading());

    final DataListState eventState = await _voteProvider.fetchVoteList();

    emit(eventState);
  }

  final VoteProvider _voteProvider = VoteProvider();
}