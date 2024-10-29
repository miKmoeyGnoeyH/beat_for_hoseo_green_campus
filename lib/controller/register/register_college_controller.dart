

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../data/models/register_basics_state.dart';
import 'register_basic_events.dart';

class RegisterCollegeController extends Bloc<RegisterBasicEvent, RegisterBasicState> {
  RegisterCollegeController() : super(RegisterBasicInformState('')) {
    on<RegisterBasicInformInitial>(_onRegisterCollegeInit);
    on<RegisterBasicInformChangedByIndex>(_onRegisterCollegeChangedByIndex);
  }

  void _onRegisterCollegeInit(RegisterBasicEvent event, Emitter<RegisterBasicState> emit) {
    emit(RegisterBasicInformState(colleges.first));
  }

  void _onRegisterCollegeChangedByIndex(RegisterBasicInformChangedByIndex event,
      Emitter<RegisterBasicState> emit) {
    emit(RegisterBasicInformState(colleges[event.index]));
  }

  final List<String> colleges = 'colleges'.tr().split(',');
}