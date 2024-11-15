
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/provider/data_list_provider.dart';
import '../../../data/states/data_list_state.dart';
import '../events/data_events.dart';

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