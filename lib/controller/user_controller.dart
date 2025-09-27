import 'dart:developer';

import 'package:beat_flutter/managers/localization/localization_manager.dart';
import 'package:beat_flutter/managers/prefs/prefs_manager.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../data/models/user_model.dart';
import '../data/provider/user_provider.dart';
import '../managers/navigator/arguments/screen_holder_arguments.dart';
import '../managers/navigator/navigator_key_manager.dart';
import '../managers/navigator/routes.dart';

sealed class UserEvent {}

final class Init extends UserEvent {}

final class SignIn extends UserEvent {
  SignIn(this.studentId, this.password);

  final String studentId;
  final String password;
}

final class SignOut extends UserEvent {}

final class GetMyNeuro extends UserEvent {}

class UserController extends Bloc<UserEvent, User> {
  final UserProvider _userProvider = UserProvider();

  UserController() : super(Guest()) {
    on<SignIn>(_signIn);
    on<SignOut>(_signOut);
    on<GetMyNeuro>(_getMyNeuro);
    if(PrefsManager().isStudentIdSaved() && PrefsManager().isPasswordSaved()) {
      add(
        SignIn(
          PrefsManager().getSavedStudentId(),
          PrefsManager().getSavedPassword(),
        ),
      );
    }
  }

  Future<void> _signIn(SignIn event, Emitter<User> emit) async {
    log("UserController : _signIn");
    emit(IsLoading());

    final LocalizationManager localizationManager = LocalizationManager();

    User user;
    user = await _userProvider.signIn(event.studentId, event.password);

    if (user is Member) {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      // log('user_controller.dart : _signIn : fcmToken : $fcmToken');

      if (fcmToken == null) {
        user = ErrorUser(localizationManager.errorsConnectionError);
      } else {
        if (await _userProvider.registerToken(user.authorization, fcmToken)) {
          // log("FlutterNativeSplash.remove()");
          FlutterNativeSplash.remove();
          NavigatorKeyManager().pushNamedAndRemoveUntil(
            RouteNames.screenHolder,
            arguments:
                ScreenHolderArguments(user.authorization, user.sendToTime),
          );
        } else {
          user = ErrorUser(localizationManager.errorsConnectionError);
        }
      }
    }
    // log("FlutterNativeSplash.remove()");

    FlutterNativeSplash.remove();

    emit(user);
  }

  void _signOut(SignOut event, Emitter<User> emit) async {
    NavigatorKeyManager().pushNamedAndRemoveUntil(RouteNames.signIn);
    emit(Guest());
  }

  void _getMyNeuro(GetMyNeuro event, Emitter<User> emit) async {
    emit(
      IsNeuroLoading(
        state.authorization,
        state.category,
        state.studentId,
        state.name,
        state.department,
        state.email,
        state.nickname,
        state.neuroesInHand,
        state.sendToTime,
      ),
    );

    final String neuroesInHand =
        await _userProvider.myNeuro(state.authorization);
    final User user = Member(
      state.authorization,
      state.category,
      state.studentId,
      state.name,
      state.department,
      state.email,
      state.nickname,
      neuroesInHand,
      state.sendToTime,
    );

    emit(user);
  }
}
