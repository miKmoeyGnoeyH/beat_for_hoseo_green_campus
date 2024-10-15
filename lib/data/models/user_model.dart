abstract final class User {
  User(this.studentId, this.nickname, this.authorization);

  late final String studentId;
  late final String nickname;
  late final String authorization;
}

final class Guest extends User {
  Guest() : super('', '', '');
}

final class Member extends User {
  Member(super.studentId, super.nickname, super.authorization);
}