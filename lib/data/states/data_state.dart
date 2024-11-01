import '../models/data_models.dart';

sealed class DataDetailModelState {
  DataDetailModelState([this.dataModel]);

  final DataModel? dataModel;
}

final class DataDetailModelInitial extends DataDetailModelState {
  DataDetailModelInitial();
}

final class DataDetailModelLoading extends DataDetailModelState {
  DataDetailModelLoading();
}

final class DataDetailModelLoadingError extends DataDetailModelState {
  DataDetailModelLoadingError();
}

final class DataDetailModelLoadingSuccess extends DataDetailModelState {
  DataDetailModelLoadingSuccess(super.dataModel);
}