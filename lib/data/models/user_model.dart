

abstract final class User {
  User(this.studentId, this.nickname, this.authorization, this.neuroesInHand, this.isLoading, this.isError);

  final String studentId;
  final String nickname;
  final String neuroesInHand;
  final String authorization;
  final bool isLoading;
  final bool isError;
}

final class Guest extends User {
  Guest() : super('', '', '', '', false, false);
}

final class Member extends User {
  Member(studentId, nickname, authorization, neuroesInHand) : super(studentId, nickname, authorization, neuroesInHand, false, false);
}

final class IsLoading extends User {
  IsLoading() : super('', '', '', '', true, false);
}

final class ErrorUser extends User {
  ErrorUser(studentId) : super(studentId, '', '', '', false, true);
}