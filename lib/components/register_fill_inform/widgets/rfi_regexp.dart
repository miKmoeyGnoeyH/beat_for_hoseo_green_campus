final RegExp initialConsonantRegExp = RegExp(r'[ㅏ-ㅣㄱ-ㅎ]');
final RegExp emailRegExp = RegExp(
    r"^(?=.{1,64}$)([A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+)?)$");
final passwordRegex =
    RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[^A-Za-z0-9])\S{8,}$');
