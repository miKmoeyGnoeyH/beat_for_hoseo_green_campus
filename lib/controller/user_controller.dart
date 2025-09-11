import 'dart:developer';

import 'package:beat_flutter/managers/localization/localization_manager.dart';
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
  SignIn(this.studentId, this.password);

  final String studentId;
  final String password;
}

final class SignOut extends UserEvent {}

final class GetMyNeuro extends UserEvent {}

class UserController extends Bloc<UserEvent, User> {
  final UserProvider _userProvider = UserProvider();

  UserController() : super(Guest()) {
    log("UserController : init");
    on<SignIn>(_signIn);
    on<SignOut>(_signOut);
    on<GetMyNeuro>(_getMyNeuro);
    // if(PrefsManager().containsKey('saved_studentId') && PrefsManager().containsKey('saved_nickname')) {
    //   add(
    //     SignIn(
    //       PrefsManager().getValueAs<String>('saved_studentId'),
    //       PrefsManager().getValueAs<String>('saved_nickname'),
    //     ),
    //   );
    // }
  }

  Future<void> _signIn(SignIn event, Emitter<User> emit) async {
    log("UserController : _signIn");
    emit(IsLoading());

    final LocalizationManager localizationManager = LocalizationManager();

    User user;
    user = await _userProvider.signIn(event.studentId, event.password);

    if (user is Member) {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      log('user_controller.dart : _signIn : fcmToken : $fcmToken');

      if (fcmToken == null) {
        user = ErrorUser(localizationManager.errorsConnectionError);
      } else {
        if (await _userProvider.registerToken(user.authorization, fcmToken)) {
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

    emit(user);
  }

  void _signOut(SignOut event, Emitter<User> emit) {
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
