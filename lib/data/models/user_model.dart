sealed class User {
  User(
    this.authorization,
    this.category,
    this.studentId,
    this.name,
    this.department,
    this.email,
    this.nickname,
    this.neuroesInHand,
    this.sendToTime,
  );

  final String authorization;
  final String category;
  final String studentId;
  final String name;
  final String department;
  final String email;
  final String nickname;
  final String neuroesInHand;
  final int sendToTime;
}

final class Guest extends User {
  Guest() : super('', '', '','', '', '', '', '', -1);
}

final class Member extends User {
  Member(
    super.authorization,
    super.category,
    super.studentId,
    super.name,
    super.department,
    super.email,
    super.nickname,
    super.neuroesInHand,
    super.sendToTime,
  );
}

final class IsLoading extends User {
  IsLoading() : super('', '', '', '', '', '', '', '', -1);
}

final class IsNeuroLoading extends Member {
  IsNeuroLoading(
    super.authorization,
    super.category,
    super.studentId,
    super.name,
    super.department,
    super.email,
    super.nickname,
    super.neuroesInHand,
    super.sendToTime,
  );
}

final class ErrorUser extends User {
  ErrorUser(studentId) : super(studentId, '', '', '', '', '', '', '', -1);
}
