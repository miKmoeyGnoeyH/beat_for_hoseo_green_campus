sealed class QRState {}

class QRInitial extends QRState {}

class QRLoading extends QRState {}

class QRSuccess extends QRState {
  QRSuccess(this.title, this.content);
  final String title;
  final String content;
}

class QRFailure extends QRState {
  QRFailure(this.title, this.content);
  final String title;
  final String content;
}