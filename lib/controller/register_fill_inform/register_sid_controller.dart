import 'dart:async';

import 'package:beat_flutter/data/states/email_state.dart';
import 'package:beat_flutter/data/provider/email_check_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

sealed class IDRequestEvent {}

final class IDChanged extends IDRequestEvent {}

final class EmailRequest extends IDRequestEvent {}

final class IDRequest extends IDRequestEvent {}

class RegisterIDController extends Bloc<IDRequestEvent, IDState> {
  // static RegisterSidController? _instance;
  final IDCheckProvider _idCheckProvider = IDCheckProvider();
  final TextEditingController idController = TextEditingController();

  // factory RegisterSidController() => _instance ??= RegisterSidController._internal();
  RegisterIDController() : super(IDNotSent()) {
    on<IDChanged>((event, emit) => emit(IDNotSent()));
    on<EmailRequest>(_emailRequest);
    on<IDRequestEvent>(_idRequest);
  }

  Future<void> _emailRequest(
      IDRequestEvent event, Emitter<IDState> emit) async {
    emit(IDSending());

    final String studentId = idController.text;

    IDState emailState = await _idCheckProvider.emailRequest(studentId);
    emit(emailState);

    if (emailState is! IDSent) {
      emit(IDNotSent());
    }
  }

  Future<void> _idRequest(
      IDRequestEvent event, Emitter<IDState> emit) async {
    emit(IDSending());

    final String id = idController.text;

    IDState idState = await _idCheckProvider.emailRequest(id);
    emit(idState);

    if (idState is! IDSent) {
      emit(IDNotSent());
    }
  }
}
