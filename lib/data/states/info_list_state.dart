import '../models/data_models.dart';

sealed class InfoListState {}

final class InfoListInitial extends InfoListState {}

final class InfoListLoading extends InfoListState {}

final class InfoListLoaded extends InfoListState {
  InfoListLoaded(this.infoList);

  final InfoList infoList;
}

final class InfoListError extends InfoListState {}
