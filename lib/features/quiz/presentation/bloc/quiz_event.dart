part of 'quiz_bloc.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object?> get props => [];
}

class GetAllQuestionsEvent extends QuizEvent {
  final int level;

  const GetAllQuestionsEvent({required this.level});

  @override
  List<Object?> get props => [level];
}

class SelectAnswerEvent extends QuizEvent {
  final String answer;

  const SelectAnswerEvent(this.answer);

  @override
  List<Object?> get props => [answer];
}

class NextQuestionEvent extends QuizEvent {}

class TimerTickEvent extends QuizEvent {}
