import 'package:BEAT/data/models/event_model.dart';
import 'package:BEAT/data/provider/quests_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class QuestsEvent {}

class QuestsLoadingRequest extends QuestsEvent {}

class QuestsController extends Bloc<QuestsEvent, QuestsState> {
  QuestsController() : super(QuestsInitial()) {
    on<QuestsLoadingRequest>(_onQeustsLoadingRequest);
    add(QuestsLoadingRequest());
  }

  Future<void> _onQeustsLoadingRequest(QuestsEvent event, Emitter<QuestsState> emit) async {
    emit(QuestsLoading());

    final QuestsState eventState = await questsProvider.fetchQuests();

    emit(eventState);
  }

  final QuestsProvider questsProvider = QuestsProvider();
}