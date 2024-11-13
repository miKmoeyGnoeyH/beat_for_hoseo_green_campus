import 'dart:developer';

import 'package:BEAT/data/provider/vote_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/data_models.dart';
import '../../../data/states/data_state.dart';
import '../../home/events/data_events.dart';

class VoteResultController extends Bloc<DataDetailEvent, DataDetailModelState> {
  VoteResultController(this._dataModel, this._authorization) : super(DataDetailModelInitial()) {
    log('vote_result_controller : VoteResultController() : _dataModel : $_dataModel, _authorization : $_authorization');
    on<DataDetailRequest>(_onDataDetailRequest);
    add(DataDetailRequest());
  }

  void _onDataDetailRequest(DataDetailEvent event, Emitter<DataDetailModelState> emit) async {
    emit(DataDetailModelLoading());
    final DataDetailModelState dataDetailModelState = await _voteProvider.fetchVoteResult(_dataModel as VoteModel, _authorization);
    emit(dataDetailModelState);
  }

  final VoteProvider _voteProvider = VoteProvider();
  final DataModel _dataModel;
  final String _authorization;
}