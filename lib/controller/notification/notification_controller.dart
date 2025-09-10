import 'package:beat_flutter/data/provider/notice_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/states/data_list_state.dart';
import '../home/events/data_events.dart';

class NotificationsController extends Bloc<DataEvent, DataListState> {
  NotificationsController() : super(DataListInitial()) {
    on<DataListRequest>(_onDataListRequest);
    add(DataListRequest());
  }

  Future<void> _onDataListRequest(DataEvent event, Emitter<DataListState> emit) async {
    emit(DataListLoading());

    final DataListState eventState = await noticeProvider.fetchDataList();

    emit(eventState);
  }

  final NoticeProvider noticeProvider = NoticeProvider();
}