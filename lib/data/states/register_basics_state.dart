sealed class RegisterBasicState {
  RegisterBasicState(this.value);
  final String value;
}

final class RegisterBasicInformState extends RegisterBasicState {
  RegisterBasicInformState(super.value);
}