part of 'quiz_bloc.dart';

abstract class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object?> get props => [];
}

class QuizInitState extends QuizState {}

class GetAllQuestionsLoadingState extends QuizState {}

class GetAllQuestionsSuccessState extends QuizState {
  final List<Question> questions;

  const GetAllQuestionsSuccessState({required this.questions});

  @override
  List<Object?> get props => [questions];
}

class GetAllQuestionsErrorState extends QuizState {
  final String message;

  const GetAllQuestionsErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

class AnswerSelectedState extends QuizState {
  final String selectedAnswer;

  const AnswerSelectedState({required this.selectedAnswer});

  @override
  List<Object?> get props => [selectedAnswer];
}

class NextQuestionState extends QuizState {
  final int currentIndex;

  const NextQuestionState({required this.currentIndex});

  @override
  List<Object?> get props => [currentIndex];
}

class TimerTickState extends QuizState {
  final int currentTime;

  const TimerTickState({required this.currentTime});

  @override
  List<Object?> get props => [currentTime];
}
