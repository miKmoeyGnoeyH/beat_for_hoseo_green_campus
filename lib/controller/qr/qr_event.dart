sealed class QREvent {
  const QREvent(
      this.requestUrl, this.authorization, this.latitude, this.longitude);

  final String requestUrl;
  final String authorization;
  final double latitude;
  final double longitude;
}

class QRCheck extends QREvent {
  QRCheck(
      super.requestUrl, super.authorization, super.latitude, super.longitude);
}

class QRCredit extends QREvent {
  QRCredit(
      super.requestUrl, super.authorization, super.latitude, super.longitude);
}

class QRSign extends QREvent {
  QRSign(
      super.requestUrl, super.authorization, super.latitude, super.longitude);
}
