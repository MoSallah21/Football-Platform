import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/models/question_model/model.dart';
import 'package:football_platform/modules/about_football/quiz/choose_level/choose_level.dart';
import 'package:football_platform/modules/about_football/quiz/correct_answers_screen/correct_answers.dart';
import 'package:football_platform/modules/about_football/quiz/questions_screen/quiz_screen.dart';
import 'package:football_platform/modules/about_football/state_management/about_cubit.dart';
import 'package:football_platform/modules/about_football/state_management/about_state.dart';
import 'package:football_platform/modules/home/home_screen.dart';
import 'package:football_platform/shared/components/components.dart';
import 'package:football_platform/shared/components/background.dart';



class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.score, required this.questions,
    });
  final int score;
  final List<QuestionModel> questions;

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<AboutCubit,AboutState>(
      listener: (BuildContext context, state) {  },
      builder: (BuildContext context, Object? state) {
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
                      Text('النتيجة : $score/${questions.length}',
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
                      actionButton(title: 'العب مجددا',
                          buttonColor: Colors.purple,

                          onTap: (){
                            navigateTo(context, ChooseLevel());
                          }),
                      SizedBox(height: 15,),
                      actionButton(title: 'الاجابات الصحيحة',
                          buttonColor: Colors.purple,
                          onTap: (){
                            navigateTo(context, CorrectAnswer(questions: questions));
                          }),
                      SizedBox(height: 15,),
                      actionButton(title: 'القائمة الرئيسية',
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
      },

    );
  }
}
