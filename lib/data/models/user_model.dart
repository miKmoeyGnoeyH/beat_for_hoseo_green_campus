sealed class User {
  User(this.studentId, this.nickname, this.authorization, this.neuroesInHand);

  final String studentId;
  final String nickname;
  final String neuroesInHand;
  final String authorization;
}

final class Guest extends User {
  Guest() : super('', '', '', '');
}

final class Member extends User {
  Member(super.studentId, super.nickname, super.authorization, super.neuroesInHand);
}

final class IsLoading extends User {
  IsLoading() : super('', '', '', '');
}

final class ErrorUser extends User {
  ErrorUser(studentId) : super(studentId, '', '', '');
}