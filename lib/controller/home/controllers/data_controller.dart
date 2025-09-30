

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/data_models.dart';
import '../../../data/provider/data_detail_provider.dart';
import '../../../data/states/data_state.dart';
import '../events/data_events.dart';

class DataDetailModelController extends Bloc<DataDetailEvent, DataDetailModelState> {
  DataDetailModelController(this.dataModel, this.authorization) : super(DataDetailModelInitial()) {
    on<DataDetailRequest>(_onDataDetailRequest);
    add(DataDetailRequest());
  }

  void _onDataDetailRequest(DataDetailEvent event, Emitter<DataDetailModelState> emit) async {
    emit(DataDetailModelLoading());
    final DataDetailModelState dataDetailModelState = await _dataDetailProvider.fetchData(dataModel, authorization);
    emit(dataDetailModelState);
  }

  final DataDetailProvider _dataDetailProvider = DataDetailProvider();
  DataModel dataModel;
  final String authorization;
}