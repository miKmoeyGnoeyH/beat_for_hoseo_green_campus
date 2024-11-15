
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/provider/info_provider.dart';
import '../../../data/states/info_image_state.dart';
import '../events/info_image_event.dart';

class InfoImageController extends Bloc<InfoImageEvent, InfoImageState> {
  InfoImageController() : super(InfoImageInitial()) {
    on<InfoImageRequest>(_onInfoImageRequested);
    add(InfoImageRequest());
  }

  Future<void> _onInfoImageRequested(InfoImageRequest event, Emitter<InfoImageState> emit) async {
    emit(InfoImageLoading());
    InfoImageState infoImageState = await infoProvider.getInfoImages();
    emit(infoImageState);
  }

  final InfoProvider infoProvider = InfoProvider();
}