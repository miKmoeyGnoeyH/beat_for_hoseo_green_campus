
import 'package:BEAT/controller/register/register_basic_events.dart';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../data/models/register_basics_state.dart';

class RegisterDepartmentController
    extends Bloc<RegisterBasicEvent, RegisterBasicState> {
  RegisterDepartmentController.fromCollege(String college)
      : super(RegisterBasicInformState('')) {
    departments = 'departments'.tr(gender: college).split(', ');
    on<RegisterBasicInformInitial>(_onRegisterDepartmentInit);
    on<RegisterBasicInformChangedByIndex>(_onRegisterDepartmentChangedByIndex);
    add(RegisterBasicInformInitial());
  }

  RegisterDepartmentController.fromOthers(): super(RegisterBasicInformState('')) {
    departments = 'organization_details'.tr().split(', ');
    on<RegisterBasicInformInitial>(_onRegisterDepartmentInit);
    on<RegisterBasicInformChangedByIndex>(_onRegisterDepartmentChangedByIndex);
    add(RegisterBasicInformInitial());
  }

  RegisterDepartmentController.fromAffiliation(): super(RegisterBasicInformState('')) {
    on<RegisterBasicInformChangedByValue>(_onRegisterDepartmentChangedByValue);
  }

  void _onRegisterDepartmentInit(
      RegisterBasicEvent event, Emitter<RegisterBasicState> emit) {
    emit(RegisterBasicInformState(departments.first));
  }

  void _onRegisterDepartmentChangedByIndex(RegisterBasicInformChangedByIndex event,
      Emitter<RegisterBasicState> emit) {
    emit(RegisterBasicInformState(departments[event.index]));
  }

  void _onRegisterDepartmentChangedByValue(RegisterBasicInformChangedByValue event,
      Emitter<RegisterBasicState> emit) {
    emit(RegisterBasicInformState(event.value));
  }

  late final List<String> departments;
}
