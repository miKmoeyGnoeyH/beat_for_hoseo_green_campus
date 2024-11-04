part of 'data_models.dart';

class QuizModel extends DataModel {
  QuizModel({
    required this.quizId,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.neuro,
    required this.alreadySolved,
  });

  QuizModel.fromJson(Map<String, dynamic> json)
      : quizId = json['quizId'],
        title = json['title'],
        content = json['content'],
        imageUrl = json['imageUrl'],
        neuro = json['neuro'],
        alreadySolved = json['alreadySolved'];

  final int quizId;
  final String title;
  final String content;
  final String? imageUrl;
  final int neuro;
  final bool alreadySolved;
}



class QuizDetailModel extends QuizModel {
  QuizDetailModel({
    required super.quizId,
    required super.title,
    required super.content,
    required super.imageUrl,
    required super.neuro,
    required super.alreadySolved,
    required this.questionList,
  });

  QuizDetailModel.fromQuizModel(
    QuizModel quizModel, {
    required this.questionList,
  }) : super(
          quizId: quizModel.quizId,
          title: quizModel.title,
          content: quizModel.content,
          imageUrl: quizModel.imageUrl,
          neuro: quizModel.neuro,
          alreadySolved: quizModel.alreadySolved,
        );

  QuizDetailModel.fromJson(Map<String, dynamic> json)
      : questionList = (json['questionList'] as List)
            .map((question) => QuestionModel.fromJson(question))
            .toList(),
        super(
          quizId: json['quizId'],
          title: json['title'],
          content: json['content'],
          imageUrl: json['imageUrl'],
          neuro: json['neuro'],
          alreadySolved: json['alreadySolved'],
        );

  QuizDetailModel.fromModelAndJson(
      QuizModel quizModel, Map<String, dynamic> json)
      : questionList = (json['questionList'] as List)
            .map((question) => QuestionModel.fromJson(question))
            .toList(),
        super(
          quizId: quizModel.quizId,
          title: quizModel.title,
          content: quizModel.content,
          imageUrl: quizModel.imageUrl,
          neuro: quizModel.neuro,
          alreadySolved: quizModel.alreadySolved,
        );

  final List<QuestionModel> questionList;
}



class QuestionModel extends DataModel {
  QuestionModel({
    required this.questionId,
    required this.question,
    required this.imageUrl,
    required this.answerList,
    required this.subjective,
  });

  QuestionModel.fromJson(Map<String, dynamic> json)
      : answerList = (json['answerList'] as List)
            .map((answer) => AnswerModel.fromJson(answer))
            .toList(),
        questionId = json['questionId'],
        question = json['question'],
        imageUrl = json['imageUrl'],
        subjective = json['subjective'];

  final int questionId;
  final String question;
  final String? imageUrl;
  final List<AnswerModel> answerList;
  final bool subjective;
}



class AnswerModel extends DataModel {
  AnswerModel({
    required this.answerId,
    required this.answer,
    required this.correctAnswer,
    required this.imageUrl,
  });

  AnswerModel.fromJson(Map<String, dynamic> json)
      : answerId = json['answerId'],
        answer = json['answer'],
        correctAnswer = json['correctAnswer'],
        imageUrl = json['imageUrl'];

  final int answerId;
  final String answer;
  final bool correctAnswer;
  final String? imageUrl;
}
