import 'dart:async';
import 'dart:developer';

import 'package:BEAT/data/models/email_state.dart';
import 'package:BEAT/data/provider/register_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

sealed class EmailEvent {}

final class EmailRequest extends EmailEvent {}

class RegisterSidController extends Bloc<EmailEvent, EmailState> {
  static RegisterSidController? _instance;
  final RegisterProvider _registerProvider = RegisterProvider();
  final TextEditingController sidController = TextEditingController();

  factory RegisterSidController() => _instance ??= RegisterSidController._internal();
  RegisterSidController._internal() : super(EmailEnabled()) {
    log('RegisterSidController: constructor');
    on<EmailRequest>(_emailRequest);
  }

  Future<void> _emailRequest(
      EmailEvent event, Emitter<EmailState> emit) async {
    emit(EmailDisabled());

    final String studentId = sidController.text;

    EmailState emailState = await _registerProvider.emailRequest(studentId);
    emit(emailState);
    emit(EmailDisabled());

    if (emailState is EmailSent) {
      await Future.delayed(const Duration(seconds: 3));
      emit(EmailEnabled());
    } else {
      emit(EmailEnabled());
    }
  }
}
