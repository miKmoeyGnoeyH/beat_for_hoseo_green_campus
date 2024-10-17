
import '../../managers/navigator/routes.dart';

abstract final class User {
  User(this.studentId, this.nickname, this.authorization, this.neuroesInHand);

  String get userPageRoute;
  late final String studentId;
  late final String nickname;
  late final String neuroesInHand;
  late final String authorization;
}

final class Guest extends User {
  Guest() : super('', '', '', '');

  @override
  String get userPageRoute => Routes.signIn;
}

final class Member extends User {
  Member(super.studentId, super.nickname, super.authorization, super.neuroesInHand);

  @override
  String get userPageRoute => Routes.home;
}