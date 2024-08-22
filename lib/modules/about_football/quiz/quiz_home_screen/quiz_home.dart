import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/models/question_model/model.dart';
import 'package:football_platform/modules/about_football/quiz/choose_level/choose_level.dart';
import 'package:football_platform/modules/about_football/quiz/questions_screen/quiz_screen.dart';
import 'package:football_platform/modules/about_football/state_management/about_cubit.dart';
import 'package:football_platform/modules/about_football/state_management/about_state.dart';
import 'package:football_platform/shared/components/components.dart';
import 'package:football_platform/shared/components/background.dart';
import 'package:hexcolor/hexcolor.dart';


class QuizHome extends StatelessWidget {
   QuizHome({super.key, required  this.level});
    final  int level;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AboutCubit,AboutState>(
    listener: (BuildContext context, state) {  },
    builder: (BuildContext context, Object? state) {
      List<Text> levels=[
        Text('سهل',
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
        Text('متوسط',
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
        Text('صعب',
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
      ];
     var cubit=AboutCubit.get(context);
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: HexColor('#202124'),
          body: BackGround(
            img: 1,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 120.0),
                child: Column(
                  children: [
                    Text('لعبة اسئلة واجوبة',
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
                    if(level==1)
                    levels[0],
                    if(level==2)
                      levels[1],
                    if(level==3)
                      levels[2],
                    SizedBox(height: 40,),
                    StreamBuilder<List<QuestionModel>>(
                      stream: cubit.getQuestion(level:level ),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<QuestionModel>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(color: Colors.purple,),
                          );

                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );

                        } else if (!snapshot.hasData) {
                          return Center(
                            child: Text('No data'),
                          );
                        } else {
                          List<QuestionModel> questions = snapshot.data!;
                          return Column(
                            children: [
                              actionButton(title: 'بدء',
                                  buttonColor: Colors.purple,
                                  onTap: (){
                                if(questions.isNotEmpty)
                                  navigateToWithSlide(context,
                                    QuizScreen(questions: questions, totalTime: level));}),
                              SizedBox(height: 20,),
                              actionButton(title: 'رجوع',
                                  buttonColor: Colors.redAccent,
                                  onTap: (){
                                    navigateTo(context,
                                        ChooseLevel());}),
                              SizedBox(height: 20,),
                              Text('  عدد الاسئلة الاجمالي:${questions.length}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
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

                              )
                            ],
                          );
                        }
                      },
                    ),
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

