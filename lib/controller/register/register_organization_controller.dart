
import 'package:BEAT/controller/register/register_basic_events.dart';
import 'package:BEAT/data/states/register_basics_state.dart';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class RegisterOrganizationController
    extends Bloc<RegisterBasicEvent, RegisterBasicState> {
  RegisterOrganizationController() : super(RegisterBasicInformState('')) {
    on<RegisterBasicInformInitial>(_onRegisterOrganizationInit);
    on<RegisterBasicInformChangedByIndex>(_onRegisterOrganizationChangedByIndex);
    add(RegisterBasicInformInitial());
  }

  void _onRegisterOrganizationInit(RegisterBasicEvent event, Emitter<RegisterBasicState> emit) {
    emit(RegisterBasicInformState(organizations.first));
  }

  void _onRegisterOrganizationChangedByIndex(RegisterBasicInformChangedByIndex event,
      Emitter<RegisterBasicState> emit) {
    emit(RegisterBasicInformState(organizations[event.index]));
  }

  final List<String> organizations = [
    'student'.tr(),
    'faculty_and_staff'.tr(),
    'postgraduate_student'.tr(),
    'other'.tr()
  ];
}
