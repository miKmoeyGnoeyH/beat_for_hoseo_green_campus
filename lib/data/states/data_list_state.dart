import '../models/data_models.dart';

sealed class DataListState {
  DataListState([this.dataList = const []]);

  final List<DataModel> dataList;
}

final class DataListInitial extends DataListState {
  DataListInitial();
}

final class DataListLoading extends DataListState {
  DataListLoading();
}

final class DataListLoadingError extends DataListState {
  DataListLoadingError();
}

final class DataListLoadingSuccess extends DataListState {
  DataListLoadingSuccess(super.dataList);
}