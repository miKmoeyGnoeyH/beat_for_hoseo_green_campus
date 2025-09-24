sealed class IDState {}

final class IDNotSent extends IDState {}

final class IDSending extends IDState {}

final class IDSent extends IDState {}

final class IDEmailChecking extends IDState {}

final class IDEmailChecked extends IDState {}

final class IDEmailNotChecked extends IDState {}

final class IDEmailCheckError extends IDState {
  IDEmailCheckError(this.msg);
  final String msg;
}

final class IDError extends IDState {
  IDError(this.msg);
  final String msg;
}