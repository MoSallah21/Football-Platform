import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/core/errors/failures.dart';
import 'package:football_platform/core/strings/failures.dart';
import 'package:football_platform/features/quiz/domain/entities/question.dart';
import 'package:football_platform/features/quiz/domain/usecases/get_all_questions.dart';

import '../../data/models/quiz_results.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final GetAllQuestionsUseCase getAllQuestions;

  // Private fields with proper encapsulation
  List<Question> _questions = const [];
  int _currentIndex = 0;
  String? _selectedAnswer;
  int _currentTime = 0;
  int _score = 0;
  int _totalTime = 0;
  int _level = 1;
  bool _isQuizCompleted = false;
  bool _isAnswerLocked = false;
  Timer? _timer;

  // Public getters - using unmodifiable list for questions
  List<Question> get questions => _questions;
  int get currentIndex => _currentIndex;
  String? get selectedAnswer => _selectedAnswer;
  int get currentTime => _currentTime;
  int get score => _score;
  int get totalTime => _totalTime;
  int get level => _level;
  bool get isQuizCompleted => _isQuizCompleted;
  bool get isAnswerLocked => _isAnswerLocked;

  // Cached calculations
  int get correctAnswers => _score;
  int get totalQuestions => _questions.length;
  double get accuracyPercentage =>
      totalQuestions > 0 ? (_score / totalQuestions) * 100 : 0.0;

  // Static time configuration for performance
  static const Map<int, int> _timePerLevel = {
    1: 60, // Easy: 60 seconds
    2: 45, // Medium: 45 seconds
    3: 30, // Hard: 30 seconds
  };

  QuizBloc({required this.getAllQuestions}) : super(QuizInitState()) {
    on<GetAllQuestionsEvent>(_onGetAllQuestionsEvent);
    on<SelectAnswerEvent>(_onSelectAnswerEvent);
    on<NextQuestionEvent>(_onNextQuestionEvent);
    on<TimerTickEvent>(_onTimerTickEvent);
    on<ResetQuizEvent>(_onResetQuizEvent);
    on<PauseQuizEvent>(_onPauseQuizEvent);
    on<ResumeQuizEvent>(_onResumeQuizEvent);
    on<SkipQuestionEvent>(_onSkipQuestionEvent);
    on<QuizCompletedEvent>(_onQuizCompletedEvent);
  }

  Future<void> _onGetAllQuestionsEvent(
      GetAllQuestionsEvent event, Emitter<QuizState> emit) async {
    try {
      _level = event.level;
      emit(GetAllQuestionsLoadingState());

      final failureOrQuestions = await getAllQuestions.call(_level);

      failureOrQuestions.fold(
            (failure) {
          emit(GetAllQuestionsErrorState(
            message: _mapFailureToMessage(failure),
            failure: failure,
          ));
        },
            (questionsList) {
          if (questionsList.isEmpty) {
            emit(const GetAllQuestionsErrorState(
              message: "No questions available for this level",
            ));
            return;
          }

          // Store questions as regular list (avoid copying unnecessarily)
          _questions = questionsList;
          _totalTime = _timePerLevel[_level] ?? 30;
          _currentTime = _totalTime;
          _resetQuizState();

          emit(GetAllQuestionsSuccessState(
            questions: _questions,
            totalTime: _totalTime,
            level: _level,
          ));
        },
      );
    } catch (e) {
      emit(GetAllQuestionsErrorState(
        message: "Unexpected error occurred: ${e.toString()}",
      ));
    }
  }

  void _onSelectAnswerEvent(
      SelectAnswerEvent event, Emitter<QuizState> emit) {
    // Early return for performance
    if (_isAnswerLocked || _isQuizCompleted) return;

    _selectedAnswer = event.answer;
    _isAnswerLocked = true;

    // Inline check for better performance
    final currentQuestion = _getCurrentQuestion();
    if (currentQuestion == null) return;

    final isCorrect = currentQuestion.correctAnswer == event.answer;

    if (isCorrect) {
      _score++;
    }

    emit(AnswerSelectedState(
      selectedAnswer: _selectedAnswer!,
      isCorrect: isCorrect,
      correctAnswer: currentQuestion.correctAnswer,
      currentScore: _score,
    ));
  }

  void _onNextQuestionEvent(NextQuestionEvent event, Emitter<QuizState> emit) {
    if (_isQuizCompleted) return;

    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      _selectedAnswer = null;
      _isAnswerLocked = false;

      emit(NextQuestionState(
        currentIndex: _currentIndex,
        totalQuestions: _questions.length,
        progress: (_currentIndex + 1) / _questions.length,
      ));
    } else {
      _completeQuiz(emit);
    }
  }

  void _onTimerTickEvent(TimerTickEvent event, Emitter<QuizState> emit) {
    if (_isQuizCompleted) return;

    if (_currentTime > 0) {
      _currentTime--;

      final timeProgress = _currentTime / _totalTime;
      final isTimeWarning = timeProgress <= 0.2;

      emit(TimerTickState(
        currentTime: _currentTime,
        totalTime: _totalTime,
        progress: timeProgress,
        isWarning: isTimeWarning,
      ));
    } else {
      _completeQuiz(emit);
    }
  }

  void _onResetQuizEvent(ResetQuizEvent event, Emitter<QuizState> emit) {
    _resetQuizState();
    _timer?.cancel();
    _timer = null;
    emit(QuizResetState());
  }

  void _onPauseQuizEvent(PauseQuizEvent event, Emitter<QuizState> emit) {
    _timer?.cancel();
    emit(QuizPausedState(currentTime: _currentTime));
  }

  void _onResumeQuizEvent(ResumeQuizEvent event, Emitter<QuizState> emit) {
    emit(QuizResumedState(currentTime: _currentTime));
  }

  void _onSkipQuestionEvent(SkipQuestionEvent event, Emitter<QuizState> emit) {
    if (_isQuizCompleted || _isAnswerLocked) return;

    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      _selectedAnswer = null;
      _isAnswerLocked = false;

      emit(QuestionSkippedState(
        currentIndex: _currentIndex,
        totalQuestions: _questions.length,
      ));
    } else {
      _completeQuiz(emit);
    }
  }

  void _onQuizCompletedEvent(
      QuizCompletedEvent event, Emitter<QuizState> emit) {
    _completeQuiz(emit);
  }

  void _completeQuiz(Emitter<QuizState> emit) {
    _isQuizCompleted = true;
    _timer?.cancel();
    _timer = null;

    final results = QuizResults(
      score: _score,
      totalQuestions: _questions.length,
      accuracyPercentage: accuracyPercentage,
      timeSpent: _totalTime - _currentTime,
      level: _level,
      questions: _questions,
    );

    emit(QuizCompletedState(results: results));
  }

  void _resetQuizState() {
    _currentIndex = 0;
    _selectedAnswer = null;
    _score = 0;
    _isQuizCompleted = false;
    _isAnswerLocked = false;
  }

  // Inline method for better performance
  Question? _getCurrentQuestion() {
    return (_currentIndex >= 0 && _currentIndex < _questions.length)
        ? _questions[_currentIndex]
        : null;
  }

  String _mapFailureToMessage(Failure failure) {
    // Use switch expression for better performance (Dart 3.0+)
    return switch (failure.runtimeType) {
      Type() when failure is ServerFailure => SERVER_FAILURE_MESSAGE,
      Type() when failure is OffLineFailure => OFF_LINE_FAILURE_MESSAGE,
      Type() when failure is EmptyCacheFailure => EMPTY_CACHE_FAILURE_MESSAGE,
      _ => "Unexpected error occurred. Please try again.",
    };
  }

  // Public methods for external control
  void startTimer() {
    _timer?.cancel();
    // Timer will be managed by the UI component
  }

  void pauseTimer() {
    add(PauseQuizEvent());
  }

  void resumeTimer() {
    add(ResumeQuizEvent());
  }

  void resetQuiz() {
    add(ResetQuizEvent());
  }

  void skipQuestion() {
    add(SkipQuestionEvent());
  }

  void completeQuiz() {
    add(QuizCompletedEvent());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _timer = null;
    return super.close();
  }
}