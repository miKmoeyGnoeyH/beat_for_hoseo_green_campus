part 'quest_model.dart';
part 'quiz_model.dart';
part 'survey_model.dart';
part 'vote_model.dart';
part 'rank_model.dart';

abstract class DataModel {
  DataModel();

  DataModel.fromJson(Map<String, dynamic> json);
}