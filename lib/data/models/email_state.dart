sealed class EmailState {}

final class EmailInitial extends EmailState {}

final class EmailEnabled extends EmailState {}

final class EmailSent extends EmailState {}

final class EmailError extends EmailState {}

final class EmailDisabled extends EmailState {}
