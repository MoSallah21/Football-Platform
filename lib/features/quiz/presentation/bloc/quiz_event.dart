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

class NextQuestionEvent extends QuizEvent {
  const NextQuestionEvent();
}

class TimerTickEvent extends QuizEvent {
  const TimerTickEvent();
}

class ResetQuizEvent extends QuizEvent {
  const ResetQuizEvent();
}

class PauseQuizEvent extends QuizEvent {
  const PauseQuizEvent();
}

class ResumeQuizEvent extends QuizEvent {
  const ResumeQuizEvent();
}

class SkipQuestionEvent extends QuizEvent {
  const SkipQuestionEvent();
}

class QuizCompletedEvent extends QuizEvent {
  const QuizCompletedEvent();
}
