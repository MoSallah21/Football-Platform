import 'package:flutter/material.dart';
import 'package:football_platform/features/quiz/domain/entities/question.dart';
import 'package:football_platform/core/componants/background.dart';

class CorrectAnswerPage extends StatelessWidget {
  final List<Question> questions;

  const CorrectAnswerPage({Key? key, required this.questions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      extendBodyBehindAppBar: true,
      body: BackGround(
        img: 0,
        child: SafeArea(
          child: Column(
            children: [
              _HeaderStats(questionCount: questions.length),
              Expanded(
                child: _QuestionsList(questions: questions),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Correct Answers',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}

// ============================================================================
// Header Statistics Widget
// ============================================================================

class _HeaderStats extends StatelessWidget {
  final int questionCount;

  const _HeaderStats({required this.questionCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withValues(alpha: 204), // 0.8 opacity
            Colors.deepPurple.withValues(alpha: 204),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000), // Black with 0.2 opacity
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.quiz_outlined,
            color: Colors.white,
            size: 30,
          ),
          const SizedBox(width: 12),
          Text(
            'Total Questions: $questionCount',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Optimized Questions List
// ============================================================================

class _QuestionsList extends StatelessWidget {
  final List<Question> questions;

  const _QuestionsList({required this.questions});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      physics: const BouncingScrollPhysics(),
      itemCount: questions.length,
      // Use itemExtent for better performance if items are roughly same height
      // itemExtent: 300, // Uncomment and adjust if items are uniform height
      itemBuilder: (context, index) {
        return _QuestionCard(
          key: ValueKey(questions[index].question), // Use unique key for efficient updates
          question: questions[index],
          questionNumber: index + 1,
          animationDelay: index * 50, // Reduced for smoother stagger
        );
      },
    );
  }
}

// ============================================================================
// Question Card Widget
// ============================================================================

class _QuestionCard extends StatelessWidget {
  final Question question;
  final int questionNumber;
  final int animationDelay;

  const _QuestionCard({
    Key? key,
    required this.question,
    required this.questionNumber,
    required this.animationDelay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000), // Black with 0.1 opacity
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.grey.shade50,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _QuestionHeader(questionNumber: questionNumber),
                const SizedBox(height: 16),
                _QuestionText(text: question.question),
                const SizedBox(height: 20),
                const _CorrectAnswerBadge(),
                const SizedBox(height: 12),
                _AnswerText(answer: question.correctAnswer),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// Question Card Sub-Components
// ============================================================================

class _QuestionHeader extends StatelessWidget {
  final int questionNumber;

  const _QuestionHeader({required this.questionNumber});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.purple.shade100,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Center(
            child: Text(
              '$questionNumber',
              style: TextStyle(
                color: Colors.purple.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'Question',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
        ),
        Icon(
          Icons.help_outline,
          color: Colors.purple.shade400,
          size: 24,
        ),
      ],
    );
  }
}

class _QuestionText extends StatelessWidget {
  final String text;

  const _QuestionText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          height: 1.5,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }
}

class _CorrectAnswerBadge extends StatelessWidget {
  const _CorrectAnswerBadge();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border: Border.all(
              color: Colors.green.shade300,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green.shade600,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                'Correct Answer',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AnswerText extends StatelessWidget {
  final String answer;

  const _AnswerText({required this.answer});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.shade100,
            Colors.green.shade50,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(
          color: Colors.green.shade200,
          width: 1.5,
        ),
      ),
      child: Text(
        answer,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Colors.green.shade800,
          height: 1.4,
        ),
      ),
    );
  }
}