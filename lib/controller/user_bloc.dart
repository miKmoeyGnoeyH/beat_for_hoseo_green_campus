import 'package:bloc/bloc.dart';

import '../data/models/user_model.dart';
import '../data/provider/user_provider.dart';
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

class UserBloc extends Bloc<UserEvent, User> {
  final UserProvider _userProvider = UserProvider();

  UserBloc() : super(Guest()) {
    on<SignIn>(_signIn);
    on<SignOut>(_signOut);
  }

  Future<void> _signIn(SignIn event, Emitter<User> emit) async {
    emit(IsLoading());

    User user;
    user = await _userProvider.signIn(event.studentId, event.nickname);

    if(user is !ErrorUser) {
      NavigatorKeyManager()
        .pushNamedAndRemoveUntil(RouteNames.home);
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
