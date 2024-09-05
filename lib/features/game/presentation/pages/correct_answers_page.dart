import 'package:flutter/material.dart';
import 'package:football_platform/features/game/domain/entities/question.dart';
import 'package:football_platform/models/question_model/model.dart';
import 'package:football_platform/shared/components/background.dart';

class CorrectAnswerPage extends StatelessWidget {
  final List<Question> questions;

  CorrectAnswerPage({required this.questions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackGround(
        img: 0,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              return buildQuestionCard(questions[index]);
            },
          ),
        ),
      ),
    );
  }

  Widget buildQuestionCard(Question question) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              question.question,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Correct Answer :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              question.correctAnswer,
              style: TextStyle(fontSize: 16, color: Colors.purple,fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
