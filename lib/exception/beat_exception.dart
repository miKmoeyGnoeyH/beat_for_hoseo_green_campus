class BEATException implements Exception {
  BEATException(this.title, this.message);

  final String title;
  final String message;
}