sealed class User {
  User(
    this.studentId,
    this.nickname,
    this.neuroesInHand,
    this.authorization,
  );

  final String studentId;
  final String nickname;
  final String neuroesInHand;
  final String authorization;
}

final class Guest extends User {
  Guest() : super('', '', '', '');
}

final class Member extends User {
  Member(
    super.studentId,
    super.nickname,
    super.neuroesInHand,
    super.authorization,
  );
}

final class IsLoading extends User {
  IsLoading() : super('', '', '', '');
}

final class IsNeuroLoading extends Member {
  IsNeuroLoading(
    super.studentId,
    super.nickname,
    super.neuroesInHand,
    super.authorization,
  );
}

final class ErrorUser extends User {
  ErrorUser(studentId) : super(studentId, '', '', '');
}
