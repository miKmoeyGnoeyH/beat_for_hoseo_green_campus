
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/provider/data_list_provider.dart';
import '../../../data/states/data_list_state.dart';
import '../events/data_events.dart';

class QuizListController extends Bloc<DataEvent, DataListState> {
  QuizListController(this.authorization) : super(DataListInitial()) {
    log("QuizListController created.");
    on<DataListRequest>(_onDataListRequest);
    add(DataListRequest());
  }

  Future<void> _onDataListRequest(DataEvent event, Emitter<DataListState> emit) async {
    emit(DataListLoading());

    final DataListState eventState = await dataListProvider.fetchDataList(DataListType.quiz, authorization);

    emit(eventState);
  }

  final DataListProvider dataListProvider = DataListProvider();
  final String authorization;
}