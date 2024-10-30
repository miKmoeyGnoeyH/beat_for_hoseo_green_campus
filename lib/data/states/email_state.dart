sealed class EmailState {}

final class EmailNotSent extends EmailState {}

final class EmailSending extends EmailState {}

final class EmailSent extends EmailState {}

final class EmailError extends EmailState {}