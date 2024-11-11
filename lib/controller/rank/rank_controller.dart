import 'package:BEAT/controller/home/events/data_events.dart';
import 'package:BEAT/data/states/data_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/provider/data_list_provider.dart';

class RankController extends Bloc<DataEvent, DataListState> {
  RankController() : super(DataListInitial()) {
    on<DataListRequest>(_onDataListRequest);
    add(DataListRequest());
  }

  Future<void> _onDataListRequest(DataEvent event, Emitter<DataListState> emit) async {
    emit(DataListLoading());

    final DataListState eventState = await dataListProvider.fetchDataList(DataListType.rank);

    emit(eventState);
  }

  final DataListProvider dataListProvider = DataListProvider();
}