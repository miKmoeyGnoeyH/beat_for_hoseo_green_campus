sealed class NicknameState {}

final class NicknameNotChecked extends NicknameState {}

final class NicknameChecking extends NicknameState {}

final class NicknameAlreadyTaken extends NicknameState {}

final class NicknameChecked extends NicknameState {}

final class NicknameError extends NicknameState {}