import 'package:BEAT/controller/home/events/data_events.dart';
import 'package:BEAT/data/provider/data_list_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/states/data_list_state.dart';

class SurveyListController extends Bloc<DataEvent, DataListState> {
  SurveyListController() : super(DataListInitial()) {
    on<DataListRequest>(_onDataListRequest);
    add(DataListRequest());
  }

  Future<void> _onDataListRequest(DataEvent event, Emitter<DataListState> emit) async {
    emit(DataListLoading());

    final DataListState eventState = await dataListProvider.fetchDataList(DataListType.survey);

    emit(eventState);
  }

  final DataListProvider dataListProvider = DataListProvider();
}