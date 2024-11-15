
import 'package:bloc/bloc.dart';

import '../../../data/provider/info_provider.dart';
import '../../../data/states/info_list_state.dart';
import '../events/info_list_event.dart';

class InfoListController extends Bloc<InfoListEvent, InfoListState> {
  InfoListController() : super(InfoListInitial()) {
    on<InfoListRequest>(_onInfoListRequested);
    add(InfoListRequest());
  }

  Future<void> _onInfoListRequested(InfoListRequest event, Emitter<InfoListState> emit) async {
    emit(InfoListLoading());
    InfoListState infoListState = await infoProvider.getInfoList();
    emit(infoListState);
  }

  final InfoProvider infoProvider = InfoProvider();
}