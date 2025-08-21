import 'dart:developer';

import 'package:beat_flutter/managers/prefs/prefs_manager.dart';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../data/models/user_model.dart';
import '../data/provider/user_provider.dart';
import '../managers/navigator/arguments/screen_holder_arguments.dart';
import '../managers/navigator/navigator_key_manager.dart';
import '../managers/navigator/routes.dart';

sealed class UserEvent {}

final class Init extends UserEvent {}

final class SignIn extends UserEvent {
  SignIn(this.studentId, this.nickname);

  final String studentId;
  final String nickname;
}

final class SignOut extends UserEvent {}

final class GetMyNeuro extends UserEvent {}

class UserController extends Bloc<UserEvent, User> {
  final UserProvider _userProvider = UserProvider();

  UserController() : super(Guest()) {
    on<SignIn>(_signIn);
    on<SignOut>(_signOut);
    on<GetMyNeuro>(_getMyNeuro);
    if(PrefsManager.containsKey('saved_studentId') && PrefsManager.containsKey('saved_nickname')) {
      add(
        SignIn(
          PrefsManager.getValueAs<String>('saved_studentId'),
          PrefsManager.getValueAs<String>('saved_nickname'),
        ),
      );
    }
  }

  Future<void> _signIn(SignIn event, Emitter<User> emit) async {
    log("UserController : _signIn");
    emit(IsLoading());

    User user;
    user = await _userProvider.signIn(event.studentId, event.nickname);

    if (user is Member) {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      log('user_controller.dart : _signIn : fcmToken : $fcmToken');

      if (fcmToken == null) {
        user = ErrorUser('connection_error'.tr());
      } else {
        if (await _userProvider.registerToken(user.authorization, fcmToken)) {
          NavigatorKeyManager().pushNamedAndRemoveUntil(
            RouteNames.screenHolder,
            arguments: ScreenHolderArguments(user.authorization),
          );
        } else {
          user = ErrorUser('connection_error'.tr());
        }
      }
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

  void _getMyNeuro(GetMyNeuro event, Emitter<User> emit) async {
    emit(
      IsNeuroLoading(
        state.studentId,
        state.nickname,
        state.neuroesInHand,
        state.authorization,
      ),
    );

    final String neuroesInHand =
        await _userProvider.myNeuro(state.authorization);
    final User user = Member(
      state.studentId,
      state.nickname,
      neuroesInHand,
      state.authorization,
    );

    emit(user);
  }
}
