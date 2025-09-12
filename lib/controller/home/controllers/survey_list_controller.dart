
import 'package:beat_flutter/data/provider/survey_list_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/states/data_list_state.dart';
import '../events/data_events.dart';

class SurveyListController extends Bloc<DataEvent, DataListState> {
  SurveyListController() : super(DataListInitial()) {
    on<DataListRequest>(_onDataListRequest);
    add(DataListRequest());
  }

  Future<void> _onDataListRequest(DataEvent event, Emitter<DataListState> emit) async {
    emit(DataListLoading());

    final DataListState eventState = await dataListProvider.fetchSurveyList();
    // final DataListState eventState = await dataListProvider.fetchSurveyListTest();

    emit(eventState);
  }

  final SurveyListProvider dataListProvider = SurveyListProvider();
}