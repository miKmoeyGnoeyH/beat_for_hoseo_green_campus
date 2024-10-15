import 'package:bloc/bloc.dart';

import '../data/models/user_model.dart';
import '../data/provider/prefs_provider.dart';
import '../data/provider/user_provider.dart';

sealed class UserEvent {}

final class Init extends UserEvent {}

final class SignIn extends UserEvent {}

class UserBloc extends Bloc<UserEvent, User> {
  final UserProvider _userProvider = UserProvider();

  UserBloc(String studentId, String nickname) : super(Guest()) {
    on<Init>(_init);
  }

  Future<void> _init(Init event, Emitter<User> emit) async {
    PrefsProvider prefsProvider = PrefsProvider();
    String? studentId = prefsProvider.getValueAs('saved_studentId');
    String? nickname = prefsProvider.getValueAs('saved_nickname');

    if (studentId != null && nickname != null) {
      User user = await _userProvider.signIn(studentId, nickname);
      emit(user);
    } else {
      emit(Guest());
    }
  }
}
