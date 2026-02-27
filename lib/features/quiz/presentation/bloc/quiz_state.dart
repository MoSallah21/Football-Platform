part of 'quiz_bloc.dart';

abstract class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object?> get props => [];
}

class QuizInitState extends QuizState {
  const QuizInitState();
}

class GetAllQuestionsLoadingState extends QuizState {
  const GetAllQuestionsLoadingState();
}

class GetAllQuestionsSuccessState extends QuizState {
  final List<Question> questions;
  final int totalTime;
  final int level;

  const GetAllQuestionsSuccessState({
    required this.questions,
    required this.totalTime,
    required this.level,
  });

  @override
  List<Object?> get props => [questions, totalTime, level];
}

class GetAllQuestionsErrorState extends QuizState {
  final String message;
  final Failure? failure;

  const GetAllQuestionsErrorState({
    required this.message,
    this.failure,
  });

  @override
  List<Object?> get props => [message, failure];
}

class AnswerSelectedState extends QuizState {
  final String selectedAnswer;
  final bool isCorrect;
  final String correctAnswer;
  final int currentScore;

  const AnswerSelectedState({
    required this.selectedAnswer,
    required this.isCorrect,
    required this.correctAnswer,
    required this.currentScore,
  });

  @override
  List<Object?> get props => [
    selectedAnswer,
    isCorrect,
    correctAnswer,
    currentScore,
  ];
}

class NextQuestionState extends QuizState {
  final int currentIndex;
  final int totalQuestions;
  final double progress;

  const NextQuestionState({
    required this.currentIndex,
    required this.totalQuestions,
    required this.progress,
  });

  @override
  List<Object?> get props => [currentIndex, totalQuestions, progress];
}

class TimerTickState extends QuizState {
  final int currentTime;
  final int totalTime;
  final double progress;
  final bool isWarning;

  const TimerTickState({
    required this.currentTime,
    required this.totalTime,
    required this.progress,
    required this.isWarning,
  });

  @override
  List<Object?> get props => [currentTime, totalTime, progress, isWarning];
}

class QuizCompletedState extends QuizState {
  final QuizResults results;

  const QuizCompletedState({required this.results});

  @override
  List<Object?> get props => [results];
}

class QuizResetState extends QuizState {
  const QuizResetState();
}

class QuizPausedState extends QuizState {
  final int currentTime;

  const QuizPausedState({required this.currentTime});

  @override
  List<Object?> get props => [currentTime];
}

class QuizResumedState extends QuizState {
  final int currentTime;

  const QuizResumedState({required this.currentTime});

  @override
  List<Object?> get props => [currentTime];
}

class QuestionSkippedState extends QuizState {
  final int currentIndex;
  final int totalQuestions;

  const QuestionSkippedState({
    required this.currentIndex,
    required this.totalQuestions,
  });

  @override
  List<Object?> get props => [currentIndex, totalQuestions];
}