import 'package:football_platform/features/game/domain/entities/question.dart';

class QuestionModel extends Question{
  QuestionModel({
    required super.id,
    required super.question,
    required super.level,
    required super.correctAnswer,
    required super.answers,
  });
  factory QuestionModel.fromJson(Map<String, dynamic>? json) {
    return QuestionModel(
    id : json!['id'],
    question : json['question'],
    level:json['level'],
    correctAnswer : json['correctAnswer'],
    answers : json['answers'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'level':level,
      'correctAnswer': correctAnswer,
      'answers':answers
    };
  }
}
