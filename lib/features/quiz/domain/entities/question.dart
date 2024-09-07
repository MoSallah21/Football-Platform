import 'package:equatable/equatable.dart';

class Question extends Equatable{
  final String id;
  final String question;
  final int level;
  final String correctAnswer;
  final List<dynamic>? answers ;

  Question({
    required this.id,
    required this.question,
    required this.level,
    required this.correctAnswer,
    required this.answers,
    });

  @override
  List<Object?> get props => [id,question,level,correctAnswer,answers];

}