import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/features/quiz/domain/entities/question.dart';
import 'package:football_platform/features/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:football_platform/features/quiz/presentation/pages/result_page.dart';
import 'package:football_platform/core/componants/components.dart';
import 'package:football_platform/core/componants/background.dart';
import 'package:hexcolor/hexcolor.dart';

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({
    super.key,
    required this.questions,
    required this.totalTime,
  });

  final List<Question> questions;
  final int totalTime;

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  late final int _initialTime;
  late final AnimationController _progressController;
  bool _isNavigating = false;
  bool _isDisposed = false;

  // Cache colors and static values for better performance
  static final _backgroundColor = HexColor('#202124');
  static final _timerBackgroundColor = HexColor('#202124');
  static const _timerProgressColor = Colors.purple;
  static const _questionTextColor = Colors.white;
  static const _shadowColor = Colors.purple;

  // Cache computed values
  late final int _questionCount;

  @override
  void initState() {
    super.initState();
    _questionCount = widget.questions.length;
    _initializeTimer();
    _initializeAnimations();
  }

  void _initializeTimer() {
    final bloc = context.read<QuizBloc>();
    _initialTime = bloc.currentTime;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      _onTimerTick,
    );
  }

  void _initializeAnimations() {
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  void _onTimerTick(Timer timer) {
    if (_isNavigating || _isDisposed) {
      timer.cancel();
      return;
    }

    final bloc = context.read<QuizBloc>();

    if (bloc.currentTime > 0) {
      bloc.add(TimerTickEvent());
    } else {
      _handleTimeUp();
    }
  }

  void _handleTimeUp() {
    if (_isDisposed) return;

    _timer?.cancel();
    if (!_isNavigating) {
      _navigateToResultScreen();
    }
  }

  void _navigateToResultScreen() {
    if (_isNavigating || _isDisposed) return;

    _isNavigating = true;
    _timer?.cancel();

    final bloc = context.read<QuizBloc>();

    navigateAndFinish(
      context,
      ResultPage(
        score: bloc.score,
        questions: widget.questions,
      ),
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    _timer?.cancel();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBackButton,
      child: BlocConsumer<QuizBloc, QuizState>(
        // Optimize listener - only listen to completion states
        listenWhen: (previous, current) => current is QuizCompletedState,
        listener: _handleStateChange,
        // Optimize builder - prevent rebuilds for same state types
        buildWhen: (previous, current) =>
        previous.runtimeType != current.runtimeType ||
            current is TimerTickState ||
            current is AnswerSelectedState ||
            current is NextQuestionState,
        builder: _buildQuizContent,
      ),
    );
  }

  Future<bool> _handleBackButton() async {
    if (_isDisposed) return true;

    final shouldExit = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _ExitDialog(),
    );

    return shouldExit ?? false;
  }

  void _handleStateChange(BuildContext context, QuizState state) {
    if (state is QuizCompletedState && !_isNavigating && !_isDisposed) {
      _navigateToResultScreen();
    }
  }

  Widget _buildQuizContent(BuildContext context, QuizState state) {
    // Early returns for edge cases
    if (state is GetAllQuestionsLoadingState) {
      return _LoadingScaffold();
    }

    if (state is GetAllQuestionsErrorState) {
      return _ErrorScaffold(message: state.message);
    }

    final bloc = context.read<QuizBloc>();

    // Validate current index
    if (bloc.currentIndex >= _questionCount) {
      return _CompletedScaffold();
    }

    final currentQuestion = widget.questions[bloc.currentIndex];

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: BackGround(
        img: 1,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _QuestionHeader(
                  currentIndex: bloc.currentIndex,
                  totalQuestions: _questionCount,
                  score: bloc.score,
                ),
                const SizedBox(height: 32),
                _TimerWidget(
                  currentTime: bloc.currentTime,
                  initialTime: _initialTime,
                ),
                const SizedBox(height: 32),
                _ProgressIndicator(
                  currentIndex: bloc.currentIndex,
                  totalQuestions: _questionCount,
                ),
                const SizedBox(height: 24),
                _QuestionText(question: currentQuestion.question),
                const SizedBox(height: 24),
                _AnswersList(
                  question: currentQuestion,
                  selectedAnswer: bloc.selectedAnswer,
                  onAnswerSelected: _handleAnswerSelection,
                  isNavigating: _isNavigating,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleAnswerSelection(String answer, Question currentQuestion) {
    if (_isNavigating || _isDisposed) return;

    final bloc = context.read<QuizBloc>();

    // Prevent multiple selections
    if (bloc.selectedAnswer != null) return;

    bloc.add(SelectAnswerEvent(answer));

    // Delay before next question for user feedback
    Future.delayed(const Duration(milliseconds: 800), () {
      if (_isNavigating || _isDisposed) return;

      if (bloc.currentIndex >= _questionCount - 1) {
        _navigateToResultScreen();
      } else {
        bloc.add(NextQuestionEvent());
      }
    });
  }
}

// ============================================================================
// Stateless Widgets for Better Performance
// ============================================================================

class _LoadingScaffold extends StatelessWidget {
  const _LoadingScaffold();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
        ),
      ),
    );
  }
}

class _ErrorScaffold extends StatelessWidget {
  final String message;

  const _ErrorScaffold({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _CompletedScaffold extends StatelessWidget {
  const _CompletedScaffold();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Quiz completed!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _ExitDialog extends StatelessWidget {
  const _ExitDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Exit Quiz?'),
      content: const Text(
        'Are you sure you want to exit the quiz? Your progress will be lost.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Exit'),
        ),
      ],
    );
  }
}

class _QuestionHeader extends StatelessWidget {
  final int currentIndex;
  final int totalQuestions;
  final int score;

  const _QuestionHeader({
    required this.currentIndex,
    required this.totalQuestions,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Question ${currentIndex + 1}/$totalQuestions',
          style: const TextStyle(
            color: _QuestionsPageState._questionTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          'Score: $score',
          style: const TextStyle(
            color: _QuestionsPageState._questionTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _TimerWidget extends StatelessWidget {
  final int currentTime;
  final int initialTime;

  const _TimerWidget({
    required this.currentTime,
    required this.initialTime,
  });

  static String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final timeProgress = currentTime / initialTime;
    final isLowTime = timeProgress <= 0.3;

    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Stack(
          fit: StackFit.expand,
          children: [
            LinearProgressIndicator(
              value: timeProgress,
              backgroundColor: _QuestionsPageState._timerProgressColor,
              valueColor: AlwaysStoppedAnimation<Color>(
                isLowTime ? Colors.red : _QuestionsPageState._timerBackgroundColor,
              ),
            ),
            Center(
              child: Text(
                _formatTime(currentTime),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalQuestions;

  const _ProgressIndicator({
    required this.currentIndex,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentIndex + 1) / totalQuestions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Progress',
          style: TextStyle(
            color: _QuestionsPageState._questionTextColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

class _QuestionText extends StatelessWidget {
  final String question;

  const _QuestionText({required this.question});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        question,
        style: const TextStyle(
          color: _QuestionsPageState._questionTextColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
          height: 1.4,
          shadows: [
            Shadow(
              color: _QuestionsPageState._shadowColor,
              offset: Offset(1, 1),
              blurRadius: 3,
            ),
          ],
        ),
      ),
    );
  }
}

class _AnswersList extends StatelessWidget {
  final Question question;
  final String? selectedAnswer;
  final Function(String, Question) onAnswerSelected;
  final bool isNavigating;

  const _AnswersList({
    required this.question,
    required this.selectedAnswer,
    required this.onAnswerSelected,
    required this.isNavigating,
  });

  @override
  Widget build(BuildContext context) {
    if (question.answers == null || question.answers!.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text(
            'No answers available',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.separated(
        // Optimize list performance
        physics: const BouncingScrollPhysics(),
        itemCount: question.answers!.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final answer = question.answers![index];
          return AnswerTile(
            key: ValueKey('${question.question}_$index'),
            isSelected: answer == selectedAnswer,
            answer: answer,
            correctAnswer: question.correctAnswer ?? '',
            onTap: isNavigating
                ? () {} // Disable tap when navigating
                : () => onAnswerSelected(answer, question),
            index: index,
          );
        },
      ),
    );
  }
}

// ============================================================================
// Optimized AnswerTile with Animation
// ============================================================================

class AnswerTile extends StatefulWidget {
  final bool isSelected;
  final String answer;
  final String correctAnswer;
  final VoidCallback onTap;
  final int index;

  const AnswerTile({
    Key? key,
    required this.isSelected,
    required this.answer,
    required this.correctAnswer,
    required this.onTap,
    required this.index,
  }) : super(key: key);

  @override
  State<AnswerTile> createState() => _AnswerTileState();
}

class _AnswerTileState extends State<AnswerTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isDisposed = false;

  // Cache letter
  late final String _letter;

  @override
  void initState() {
    super.initState();
    _letter = String.fromCharCode(65 + widget.index);
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(AnswerTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_isDisposed) return;

    if (widget.isSelected && !oldWidget.isSelected) {
      _animationController.forward();
    } else if (!widget.isSelected && oldWidget.isSelected) {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _animationController.dispose();
    super.dispose();
  }

  Color _getCardColor() {
    if (!widget.isSelected) return Colors.white;
    return widget.answer == widget.correctAnswer ? Colors.green : Colors.red;
  }

  Color _getTextColor() {
    return widget.isSelected ? Colors.white : Colors.black87;
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = _getCardColor();
    final textColor = _getTextColor();
    final isCorrect = widget.answer == widget.correctAnswer;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _AnswerIcon(
                    letter: _letter,
                    isSelected: widget.isSelected,
                    textColor: textColor,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      widget.answer,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                        height: 1.3,
                      ),
                    ),
                  ),
                  if (widget.isSelected) ...[
                    const SizedBox(width: 8),
                    Icon(
                      isCorrect ? Icons.check_circle : Icons.cancel,
                      color: Colors.white,
                      size: 24,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnswerIcon extends StatelessWidget {
  final String letter;
  final bool isSelected;
  final Color textColor;

  const _AnswerIcon({
    required this.letter,
    required this.isSelected,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected
            ? Colors.white.withOpacity(0.3)
            : Colors.grey.withOpacity(0.3),
      ),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}