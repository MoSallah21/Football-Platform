import 'package:flutter/material.dart';
import 'package:football_platform/models/question_model/model.dart';
import 'package:football_platform/shared/components/background.dart';

class CorrectAnswer extends StatelessWidget {
  final List<QuestionModel> questions;

  CorrectAnswer({required this.questions});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
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
      ),
    );
  }

  Widget buildQuestionCard(QuestionModel question) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'السؤال:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              question.question,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'الاجابة الصحيحة:',
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
