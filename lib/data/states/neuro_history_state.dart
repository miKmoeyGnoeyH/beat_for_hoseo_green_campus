import 'package:BEAT/data/models/neuro_history_model.dart';

sealed class NeuroHistoryState {
  NeuroHistoryState(this.neuroHistoryList);

  final List<NeuroHistoryModel> neuroHistoryList;
}

final class NeuroHistoryInitial extends NeuroHistoryState {
  NeuroHistoryInitial() : super([]);
}

final class NeuroHistoryLoading extends NeuroHistoryState {
  NeuroHistoryLoading() : super([]);
}

final class NeuroHistoryLoadingError extends NeuroHistoryState {
  NeuroHistoryLoadingError() : super([]);
}

final class NeuroHistoryLoadingSuccess extends NeuroHistoryState {
  NeuroHistoryLoadingSuccess(super.neuroHistoryList);
}
