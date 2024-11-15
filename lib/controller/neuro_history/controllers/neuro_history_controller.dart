import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/provider/neuro_history_provider.dart';
import '../../../data/states/neuro_history_state.dart';
import '../events/neuro_history_event.dart';

class NeuroHistoryController extends Bloc<NeuroHistoryEvent, NeuroHistoryState> {
  NeuroHistoryController(this._authorization): super(NeuroHistoryInitial()) {
    on<NeuroHistoryRequestEvent>(_onNeuroHistoryRequest);
    add(NeuroHistoryRequestEvent());
  }

  void _onNeuroHistoryRequest(NeuroHistoryRequestEvent event, Emitter<NeuroHistoryState> emit) async {
    emit(NeuroHistoryLoading());
    final NeuroHistoryState eventState = await _neuroHistoryProvider.getNeuroHistoryList(_authorization);
    emit(eventState);
  }

  final NeuroHistoryProvider _neuroHistoryProvider = NeuroHistoryProvider();
  final String _authorization;
}