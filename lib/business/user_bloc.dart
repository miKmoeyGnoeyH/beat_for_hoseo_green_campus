import 'dart:developer';

import 'package:beat_flutter/pages/routes/navigator_key_manager.dart';
import 'package:bloc/bloc.dart';

import '../data/models/user_model.dart';
import '../data/provider/prefs_provider.dart';
import '../data/provider/user_provider.dart';
import '../pages/routes/routes.dart';

sealed class UserEvent {}

final class Init extends UserEvent {}

final class SignIn extends UserEvent {
  SignIn(this.studentId, this.nickname);

  final String studentId;
  final String nickname;
}

final class SignOut extends UserEvent {}

class UserBloc extends Bloc<UserEvent, User> {
  static final UserBloc _instance = UserBloc._internal();
  final UserProvider _userProvider = UserProvider();

  factory UserBloc() => _instance;

  UserBloc._internal() : super(Guest()) {
    on<Init>(_init);
    on<SignIn>(_signIn);
    on<SignOut>(_signOut);
  }

  Future<void> _init(Init event, Emitter<User> emit) async {
    log("UserBloc: _init()");
    String studentId = PrefsProvider.getValueAs<String>('saved_studentId');
    String nickname = PrefsProvider.getValueAs<String>('saved_nickname');

    if (studentId == PrefsProvider.defaultValue<String>() ||
        nickname == PrefsProvider.defaultValue<String>()) {
      emit(Guest());
    } else {
      add(SignIn(studentId, nickname));
    }
  }

  Future<void> _signIn(SignIn event, Emitter<User> emit) async {
    User user;

    try {
      user = await _userProvider.signIn(event.studentId, event.nickname);
      NavigatorKeyManager()
          .navigatorState!
          .pushNamedAndRemoveUntil(Routes.home, (route) => false);
    } on Exception {
      user = Guest();
    }

    emit(user);
  }

  void _signOut(SignOut event, Emitter<User> emit) {
    emit(Guest());
  }
}
