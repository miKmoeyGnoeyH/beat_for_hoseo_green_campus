import 'dart:developer';

import 'package:BEAT/data/models/vote_model.dart';
import 'package:BEAT/data/provider/vote_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/data_models.dart';
import '../../data/states/data_state.dart';
import '../home/events/data_events.dart';

class VoteDetailController extends Bloc<DataDetailEvent, DataDetailModelState> {
  VoteDetailController(this.dataModel) : super(DataDetailModelInitial()) {
    log('vote_detail_controoler : VoteDetailController()');
    on<DataDetailRequest>(_onDataDetailRequest);
    add(DataDetailRequest());
  }

  void _onDataDetailRequest(DataDetailEvent event, Emitter<DataDetailModelState> emit) async {
    emit(DataDetailModelLoading());
    final DataDetailModelState dataDetailModelState = await _voteProvider.fetchVoteDetail(dataModel as VoteModel);
    emit(dataDetailModelState);
  }

  final VoteProvider _voteProvider = VoteProvider();
  DataModel dataModel;
}