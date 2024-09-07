import 'package:flutter/material.dart';
import 'package:football_platform/features/quiz/domain/entities/question.dart';
import 'package:football_platform/features/quiz/presentation/pages/choose_level_page.dart';
import 'package:football_platform/features/quiz/presentation/pages/correct_answers_page.dart';
import 'package:football_platform/modules/home/home_screen.dart';
import 'package:football_platform/shared/components/components.dart';
import 'package:football_platform/shared/components/background.dart';



class ResultPage extends StatelessWidget {
  const ResultPage({
    super.key,
    required this.score, required this.questions,
    });
  final int score;
  final List<Question> questions;

  @override
  Widget build(BuildContext context) {
    return  Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: BackGround(
          img: 1,
          child: SizedBox.expand(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Result : $score/${questions.length}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      shadows: [
                        Shadow(
                          color: Colors
                              .purple, // Change to the desired purple color
                          offset: Offset(2,
                              1), // Adjust the offset based on your preference
                          blurRadius:
                          2, // Adjust the blur radius based on your preference
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40,),
                  actionButton(title: 'Play again',
                      buttonColor: Colors.purple,

                      onTap: (){
                        navigateTo(context, ChooseLevelPage());
                      }),
                  SizedBox(height: 15,),
                  actionButton(title: 'Correct Answers',
                      buttonColor: Colors.purple,
                      onTap: (){
                        navigateTo(context, CorrectAnswerPage(questions: questions));
                      }),
                  SizedBox(height: 15,),
                  actionButton(title: 'Home',
                      buttonColor: Colors.purple,

                      onTap: (){
                        navigateAndFinish(context, HomeScreen());
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
