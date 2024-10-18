import 'dart:developer';
import 'package:bloc/bloc.dart';

import '../data/models/user_model.dart';
import '../data/provider/user_provider.dart';
import '../managers/navigator/navigator_key_manager.dart';
import '../managers/navigator/routes.dart';
import '../managers/prefs/prefs_manager.dart';

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
    String studentId = PrefsManager.getValueAs<String>('saved_studentId');
    String nickname = PrefsManager.getValueAs<String>('saved_nickname');

    if (studentId == PrefsManager.defaultValue<String>() ||
        nickname == PrefsManager.defaultValue<String>()) {
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
          .pushNamedAndRemoveUntil(RouteNames.home, (route) => false);
    } on Exception {
      user = Guest();
    }

    emit(user);
  }

  void _signOut(SignOut event, Emitter<User> emit) {
    NavigatorKeyManager().navigatorState!.pushNamedAndRemoveUntil(
          RouteNames.signIn,
          (route) => false,
        );
    emit(Guest());
  }
}
