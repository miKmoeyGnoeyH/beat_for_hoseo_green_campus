import 'package:BEAT/controller/home/data_events.dart';
import 'package:BEAT/data/provider/data_list_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/states/data_list_state.dart';

class QuestListController extends Bloc<DataListEvent, DataListState> {
  QuestListController() : super(DataListInitial()) {
    on<DataListRequest>(_onDataListRequest);
    add(DataListRequest());
  }

  Future<void> _onDataListRequest(DataListEvent event, Emitter<DataListState> emit) async {
    emit(DataListLoading());

    final DataListState eventState = await dataListProvider.fetchDataList(DataListType.quest);

    emit(eventState);
  }

  final DataListProvider dataListProvider = DataListProvider();
}