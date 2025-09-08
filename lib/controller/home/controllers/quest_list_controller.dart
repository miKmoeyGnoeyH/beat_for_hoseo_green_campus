import 'package:beat_flutter/controller/home/events/data_events.dart';
import 'package:beat_flutter/data/provider/quest_list_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/states/data_list_state.dart';

class QuestListController extends Bloc<DataEvent, DataListState> {
  QuestListController(this.authorization) : super(DataListInitial()) {
    on<DataListRequest>(_onDataListRequest);
    add(DataListRequest());
  }

  Future<void> _onDataListRequest(DataEvent event, Emitter<DataListState> emit) async {
    emit(DataListLoading());

    final DataListState eventState = await questListProvider.fetchQuestList(authorization);
    // final DataListState eventState = await questListProvider.fetchQuestListTest();
    // log("QuestListController : _onDataListRequest : eventState : ${eventState.dataList.toString()}");

    emit(eventState);
  }

  final QuestListProvider questListProvider = QuestListProvider();
  final String authorization;
}