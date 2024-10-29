sealed class RegisterBasicEvent {}

final class RegisterBasicInformInitial extends RegisterBasicEvent {}

final class RegisterBasicInformChangedByIndex extends RegisterBasicEvent {
  RegisterBasicInformChangedByIndex(this.index);

  final int index;
}

final class RegisterBasicInformChangedByValue extends RegisterBasicEvent {
  RegisterBasicInformChangedByValue(this.value);

  final String value;
}