sealed class QREvent {
  const QREvent(this.requestUrl, this.authorization);

  final String requestUrl;
  final String authorization;
}

class QRCheck extends QREvent {
  QRCheck(super.requestUrl, super.authorization);
}

class QRCredit extends QREvent {
  QRCredit(super.requestUrl, super.authorization);
}

class QRSign extends QREvent {
  QRSign(super.requestUrl, super.authorization);
}
