sealed class VoteListEvent {}

final class VoteListRequest extends VoteListEvent {
  VoteListRequest(this.authorization);
  final String authorization;
}