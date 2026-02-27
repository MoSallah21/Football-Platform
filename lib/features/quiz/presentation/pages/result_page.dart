import 'package:flutter/material.dart';
import 'package:football_platform/features/quiz/domain/entities/question.dart';
import 'package:football_platform/features/quiz/presentation/pages/choose_level_page.dart';
import 'package:football_platform/features/quiz/presentation/pages/correct_answers_page.dart';
import 'package:football_platform/modules/home/home_screen.dart';
import 'package:football_platform/core/componants/components.dart';
import 'package:football_platform/core/componants/background.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({
    super.key,
    required this.score,
    required this.questions,
  });

  final int score;
  final List<Question> questions;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _slideAnimation;

  // Cache computed values
  late final int _totalQuestions;
  late final double _percentage;
  late final String _performanceMessage;
  late final Color _performanceColor;

  @override
  void initState() {
    super.initState();
    _totalQuestions = widget.questions.length;
    _percentage = (_totalQuestions > 0) ? (widget.score / _totalQuestions) * 100 : 0;
    _performanceMessage = _getPerformanceMessage();
    _performanceColor = _getPerformanceColor();
    _initializeAnimations();
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
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
    ));

    _animationController.forward();
  }

  String _getPerformanceMessage() {
    if (_percentage >= 90) return 'Outstanding! 🎉';
    if (_percentage >= 70) return 'Great Job! 👏';
    if (_percentage >= 50) return 'Good Effort! 👍';
    return 'Keep Practicing! 💪';
  }

  Color _getPerformanceColor() {
    if (_percentage >= 90) return Colors.green;
    if (_percentage >= 70) return Colors.blue;
    if (_percentage >= 50) return Colors.orange;
    return Colors.red;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: BackGround(
          img: 1,
          child: SafeArea(
            child: SizedBox.expand(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: _ResultDisplay(
                        score: widget.score,
                        totalQuestions: _totalQuestions,
                        percentage: _percentage,
                        performanceMessage: _performanceMessage,
                        performanceColor: _performanceColor,
                      ),
                    ),
                    const SizedBox(height: 60),
                    SlideTransition(
                      position: _slideAnimation,
                      child: _ActionButtons(questions: widget.questions),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// Result Display Widget
// ============================================================================

class _ResultDisplay extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final double percentage;
  final String performanceMessage;
  final Color performanceColor;

  const _ResultDisplay({
    required this.score,
    required this.totalQuestions,
    required this.percentage,
    required this.performanceMessage,
    required this.performanceColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Performance message
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: performanceColor.withOpacity(0.2),
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            border: Border.all(
              color: performanceColor.withOpacity(0.5),
              width: 2,
            ),
          ),
          child: Text(
            performanceMessage,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: performanceColor.withOpacity(0.8),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),

        // Score display
        Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.purple.withOpacity(0.3),
                Colors.deepPurple.withOpacity(0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Your Score',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '$score / $totalQuestions',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.purple,
                      offset: Offset(2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  color: performanceColor,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: performanceColor.withOpacity(0.5),
                      offset: const Offset(1, 1),
                      blurRadius: 3,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// Action Buttons Widget
// ============================================================================

class _ActionButtons extends StatelessWidget {
  final List<Question> questions;

  const _ActionButtons({required this.questions});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CustomButton(
            title: 'Play Again',
            icon: Icons.replay,
            gradient: const [Colors.purple, Colors.deepPurple],
            onTap: () {
              navigateTo(context, const ChooseLevelPage());
            },
          ),
          const SizedBox(height: 15),
          _CustomButton(
            title: 'Correct Answers',
            icon: Icons.check_circle_outline,
            gradient: const [Colors.green, Colors.teal],
            onTap: () {
              navigateTo(context, CorrectAnswerPage(questions: questions));
            },
          ),
          const SizedBox(height: 15),
          _CustomButton(
            title: 'Home',
            icon: Icons.home,
            gradient: const [Colors.orange, Colors.deepOrange],
            onTap: () {
              navigateAndFinish(context, const HomeScreen());
            },
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Custom Button Widget
// ============================================================================

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
        borderRadius: const BorderRadius.all(Radius.circular(20)),
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
          borderRadius: const BorderRadius.all(Radius.circular(20)),
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