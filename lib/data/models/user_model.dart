sealed class User {
  User(
    this.studentId,
    this.nickname,
    this.neuroesInHand,
    this.authorization,
    this.sendToTime,
  );

  final String studentId;
  final String nickname;
  final String neuroesInHand;
  final String authorization;
  final int sendToTime;
}

final class Guest extends User {
  Guest() : super('', '', '', '', -1);
}

final class Member extends User {
  Member(
    super.studentId,
    super.nickname,
    super.neuroesInHand,
    super.authorization,
    super.sendToTime,
  );
}

final class IsLoading extends User {
  IsLoading() : super('', '', '', '', -1);
}

final class IsNeuroLoading extends Member {
  IsNeuroLoading(
    super.studentId,
    super.nickname,
    super.neuroesInHand,
    super.authorization,
    super.sendToTime,
  );
}

final class ErrorUser extends User {
  ErrorUser(studentId) : super(studentId, '', '', '', -1);
}
