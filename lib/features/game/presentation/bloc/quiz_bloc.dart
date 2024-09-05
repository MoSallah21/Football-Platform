import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/core/errors/failures.dart';
import 'package:football_platform/core/strings/failures.dart';
import 'package:football_platform/features/game/domain/entities/question.dart';
import 'package:football_platform/features/game/domain/usecases/get_all_questions.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final GetAllQuestionsUseCase getAllQuestions;

  List<Question> questions = [];
  int currentIndex = 0;
  String selectedAnswer = '';
  int currentTime = 0;
  int score = 0;
  Timer? timer;
  late int level;

  QuizBloc({required this.getAllQuestions}) : super(QuizInitState()) {
    on<GetAllQuestionsEvent>(_onGetAllQuestionsEvent);
    on<SelectAnswerEvent>(_onSelectAnswerEvent);
    on<NextQuestionEvent>(_onNextQuestionEvent);
    on<TimerTickEvent>(_onTimerTickEvent);
  }

  Future<void> _onGetAllQuestionsEvent(
      GetAllQuestionsEvent event, Emitter<QuizState> emit) async {
    level = event.level;
    emit(GetAllQuestionsLoadingState());

    final failureOrQuestions = await getAllQuestions.call(level);

    failureOrQuestions.fold(
          (failure) => emit(GetAllQuestionsErrorState(
          message: _mapFailureToMessage(failure))),
          (questions) {
        questions = questions;
        emit(GetAllQuestionsSuccessState(questions: questions));
      },
    );
  }

  void _onSelectAnswerEvent(
      SelectAnswerEvent event, Emitter<QuizState> emit) {
    selectedAnswer = event.answer;
    emit(AnswerSelectedState(selectedAnswer: selectedAnswer));
  }

  void _onNextQuestionEvent(NextQuestionEvent event, Emitter<QuizState> emit) {
    if (currentIndex < questions.length - 1) {
      currentIndex++;
      selectedAnswer = '';
      emit(NextQuestionState(currentIndex: currentIndex));
    } else {
      // handle the end of the quiz
    }
  }

  void _onTimerTickEvent(TimerTickEvent event, Emitter<QuizState> emit) {
    if (currentTime > 0) {
      currentTime--;
      emit(TimerTickState(currentTime: currentTime));
    } else {
      timer?.cancel();
      // handle time out (e.g., move to next question)
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case OffLineFailure:
        return OFF_LINE_FAILURE_MESSAGE;
      default:
        return "Unexpected error, please try again later";
    }
  }
}


