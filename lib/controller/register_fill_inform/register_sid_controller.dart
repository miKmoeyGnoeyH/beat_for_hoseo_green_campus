import 'dart:async';

import 'package:BEAT/data/states/email_state.dart';
import 'package:BEAT/data/provider/email_check_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

sealed class EmailEvent {}

final class EmailChanged extends EmailEvent {}

final class EmailRequest extends EmailEvent {}

class RegisterSidController extends Bloc<EmailEvent, EmailState> {
  // static RegisterSidController? _instance;
  final EmailCheckProvider _emailCheckProvider = EmailCheckProvider();
  final TextEditingController sidController = TextEditingController();

  // factory RegisterSidController() => _instance ??= RegisterSidController._internal();
  RegisterSidController() : super(EmailNotSent()) {
    on<EmailChanged>((event, emit) => emit(EmailNotSent()));
    on<EmailRequest>(_emailRequest);
  }

  Future<void> _emailRequest(
      EmailEvent event, Emitter<EmailState> emit) async {
    emit(EmailSending());

    final String studentId = sidController.text;

    EmailState emailState = await _emailCheckProvider.emailRequest(studentId);
    emit(emailState);

    if (emailState is! EmailSent) {
      emit(EmailNotSent());
    }
  }
}
