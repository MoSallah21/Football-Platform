import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/features/quiz/domain/entities/question.dart';
import 'package:football_platform/features/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:football_platform/features/quiz/presentation/pages/choose_level_page.dart';
import 'package:football_platform/features/quiz/presentation/pages/questions_page.dart';
import 'package:football_platform/core/componants/components.dart';
import 'package:football_platform/core/componants/background.dart';
import 'package:hexcolor/hexcolor.dart';

class QuizHomePage extends StatefulWidget {
  final int level;

  const QuizHomePage({super.key, required this.level});

  @override
  State<QuizHomePage> createState() => _QuizHomePageState();
}

class _QuizHomePageState extends State<QuizHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Cache static values
  static final _backgroundColor = HexColor('#202124');
  bool _isDisposed = false;
  bool _hasLoadedQuestions = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Dispatch event only once when dependencies are available
    if (!_hasLoadedQuestions && !_isDisposed) {
      _hasLoadedQuestions = true;
      context.read<QuizBloc>().add(GetAllQuestionsEvent(level: widget.level));
    }
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizBloc, QuizState>(
      // Use buildWhen to prevent unnecessary rebuilds
      buildWhen: (previous, current) =>
      previous.runtimeType != current.runtimeType,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: _backgroundColor,
          body: BackGround(
            img: 1,
            child: SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildContent(context, state),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, QuizState state) {
    return SingleChildScrollView(
      // Add physics for better performance
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 60),
            const _HeaderWidget(),
            const SizedBox(height: 40),
            _LevelCard(level: widget.level),
            const SizedBox(height: 40),
            _buildStateContent(context, state),
          ],
        ),
      ),
    );
  }

  Widget _buildStateContent(BuildContext context, QuizState state) {
    if (state is GetAllQuestionsLoadingState) {
      return const _LoadingStateWidget();
    } else if (state is GetAllQuestionsErrorState) {
      return _ErrorStateWidget(message: state.message);
    } else if (state is GetAllQuestionsSuccessState) {
      return _SuccessStateWidget(
        questions: state.questions,
        level: widget.level,
      );
    }
    return const SizedBox.shrink();
  }
}

// Extract stateless widgets for better performance
class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withOpacity(0.3),
            Colors.deepPurple.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Colors.purple, Colors.deepPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.5),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.quiz,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 15),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [Colors.white, Colors.purple.shade200],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: Text(
              'Q/A Game',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                shadows: [
                  Shadow(
                    color: Colors.purple.withOpacity(0.8),
                    offset: const Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final int level;

  const _LevelCard({required this.level});

  // Cache level data as static const
  static const Map<int, Map<String, dynamic>> _levelData = {
    1: {
      'name': 'Easy',
      'icon': Icons.sentiment_satisfied,
    },
    2: {
      'name': 'Medium',
      'icon': Icons.sentiment_neutral,
    },
    3: {
      'name': 'Hard',
      'icon': Icons.sentiment_very_dissatisfied,
    },
  };

  List<Color> _getGradient() {
    switch (level) {
      case 1:
        return [Colors.green.shade400, Colors.green.shade600];
      case 2:
        return [Colors.orange.shade400, Colors.orange.shade600];
      case 3:
        return [Colors.red.shade400, Colors.red.shade600];
      default:
        return [Colors.green.shade400, Colors.green.shade600];
    }
  }

  Color _getColor() {
    switch (level) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final levelInfo = _levelData[level]!;
    final gradient = _getGradient();
    final color = _getColor();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              levelInfo['icon'] as IconData,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Level',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                levelInfo['name'] as String,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LoadingStateWidget extends StatelessWidget {
  const _LoadingStateWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Loading Questions...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              shadows: [
                Shadow(
                  color: Colors.purple.withOpacity(0.5),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorStateWidget extends StatelessWidget {
  final String message;

  const _ErrorStateWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.red.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 50,
          ),
          const SizedBox(height: 15),
          const Text(
            'Error',
            style: TextStyle(
              color: Colors.red,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              shadows: [
                Shadow(
                  color: Colors.purple.withOpacity(0.5),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SuccessStateWidget extends StatelessWidget {
  final List<Question> questions;
  final int level;

  const _SuccessStateWidget({
    required this.questions,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _StatsCard(questionCount: questions.length),
        const SizedBox(height: 30),
        _ActionButtons(questions: questions, level: level),
      ],
    );
  }
}

class _StatsCard extends StatelessWidget {
  final int questionCount;

  const _StatsCard({required this.questionCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.quiz_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Questions',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
              Text(
                '$questionCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final List<Question> questions;
  final int level;

  const _ActionButtons({
    required this.questions,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    // Capture the QuizBloc before navigation to avoid context issues
    final quizBloc = context.read<QuizBloc>();

    return Column(
      children: [
        _CustomButton(
          title: 'Start Quiz',
          icon: Icons.play_arrow,
          gradient: const [Colors.purple, Colors.deepPurple],
          onTap: () {
            if (questions.isNotEmpty) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (newContext) => BlocProvider.value(
                    value: quizBloc,
                    child: QuestionsPage(
                      questions: questions,
                      totalTime: level,
                    ),
                  ),
                ),
              );
            }
          },
        ),
        const SizedBox(height: 15),
        _CustomButton(
          title: 'Back to Levels',
          icon: Icons.arrow_back,
          gradient: const [Colors.redAccent, Colors.red],
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class _CustomButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _CustomButton({
    required this.title,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradient.first.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}