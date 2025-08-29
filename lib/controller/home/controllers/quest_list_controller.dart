
import 'dart:developer';

import 'package:beat_flutter/controller/home/events/data_events.dart';
import 'package:beat_flutter/data/provider/data_list_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/states/data_list_state.dart';

class QuestListController extends Bloc<DataEvent, DataListState> {
  QuestListController() : super(DataListInitial()) {
    on<DataListRequest>(_onDataListRequest);
    add(DataListRequest());
  }

  Future<void> _onDataListRequest(DataEvent event, Emitter<DataListState> emit) async {
    emit(DataListLoading());

    final DataListState eventState = await dataListProvider.fetchDataList(DataListType.quest);
    // final DataListState eventState = await dataListProvider.fetchQuestListTest();
    // log("QuestListController : _onDataListRequest : eventState : ${eventState.dataList.toString()}");

    emit(eventState);
  }

  final DataListProvider dataListProvider = DataListProvider();
}