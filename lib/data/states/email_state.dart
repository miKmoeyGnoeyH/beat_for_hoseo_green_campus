sealed class IDState {}

final class IDNotSent extends IDState {}

final class IDSending extends IDState {}

final class IDSent extends IDState {}

final class IDError extends IDState {}