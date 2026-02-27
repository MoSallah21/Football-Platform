import 'package:equatable/equatable.dart';

import '../../domain/entities/question.dart';

class QuizResults extends Equatable {
  final int score;
  final int totalQuestions;
  final double accuracyPercentage;
  final int timeSpent;
  final int level;
  final List<Question> questions;

  const QuizResults({
    required this.score,
    required this.totalQuestions,
    required this.accuracyPercentage,
    required this.timeSpent,
    required this.level,
    required this.questions,
  });

  String get gradeText {
    if (accuracyPercentage >= 90) return 'Excellent';
    if (accuracyPercentage >= 80) return 'Very Good';
    if (accuracyPercentage >= 70) return 'Good';
    if (accuracyPercentage >= 60) return 'Average';
    return 'Needs Improvement';
  }

  @override
  List<Object?> get props => [
        score,
        totalQuestions,
        accuracyPercentage,
        timeSpent,
        level,
        questions,
      ];
}