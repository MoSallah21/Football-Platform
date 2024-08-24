import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/models/question_model/model.dart';
import 'package:football_platform/modules/about_football/quiz/result_screen/result_screen.dart';
import 'package:football_platform/modules/about_football/state_management/about_cubit.dart';
import 'package:football_platform/modules/about_football/state_management/about_state.dart';
import 'package:football_platform/shared/components/components.dart';
import 'package:football_platform/shared/components/background.dart';
import 'package:hexcolor/hexcolor.dart';
class QuizScreen extends StatefulWidget {
   const QuizScreen({super.key, required this.questions, required this.totalTime });
   final List<QuestionModel> questions;
   final int totalTime;
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}
class _QuizScreenState extends State<QuizScreen> {
final AboutCubit cubit=AboutCubit();
int time=0;

  @override
  void initState(){
    super.initState();
    if(widget.totalTime==1){
      cubit.currentTime=40;
      time=40;

    }
    if(widget.totalTime==2){
      cubit.currentTime=30;
      time=30;
    }
    if(widget.totalTime==3){
      cubit.currentTime=20;
      time=20;
    }
    cubit.timer=Timer.periodic(Duration(seconds: 1), (timer) {
      cubit.timerLess();
    if(cubit.currentTime==0){
    timer.cancel();
    navigateAndFinish(context, ResultScreen(score: cubit.score, questions: widget.questions));
    }
    });
  }
  @override
  void dispose(){
    cubit.timer.cancel();
    super.dispose();
  }
   @override
   Widget build(BuildContext context) {
     return BlocBuilder<AboutCubit,AboutState>(
         bloc: cubit,
         builder: (BuildContext context, Object? state) {
           final currentQuestions = widget.questions[cubit.currentIndex];
           return Scaffold(
             body: BackGround(
                 img: 1,
                 child:Padding(
                     padding: const EdgeInsets.all(10.0),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       SizedBox(height: 40,),
                       SizedBox(
                         height: 40,
                         child: ClipRRect(
                           borderRadius: BorderRadius.circular(20),
                           child: Stack(
                             fit: StackFit.expand,
                             children: [
                               Directionality(
                                 textDirection: TextDirection.ltr,
                                 child: LinearProgressIndicator(
                                   color: HexColor('#202124'),
                                   backgroundColor: Colors.purple,
                                   value: cubit.currentTime/time,
                                 ),
                               ),
                               Center(
                                 child: Text(cubit.currentTime.toString(),
                                 style: TextStyle(color:Colors.white,
                                 fontWeight: FontWeight.bold,
                                   fontSize: 20,
                                 ),),
                               ),
                             ],
                           ),
                         ),
                       ),
                       SizedBox(height: 40,),
                       Text('Question :',
                         style: TextStyle(
                             color: Colors.white,
                             fontWeight: FontWeight.bold,
                             fontSize: 24,
                             shadows: [
                               Shadow(
                                 color: Colors
                                     .purple, // Change to the desired purple color
                                 offset: Offset(1,
                                     1), // Adjust the offset based on your preference
                                 blurRadius:
                                 5, // Adjust the blur radius based on your preference
                               ),
                             ]
                         ),

                       ),
                       SizedBox(height: 10,),
                       Text(currentQuestions.question,
                       style: TextStyle(
                           color: Colors.white,
                           fontSize: 24,
                       ),
                       ),
                       Expanded(
                         child: ListView.builder(
                             itemBuilder: (BuildContext context,int index)
                         {
                           final answer=currentQuestions.answers![index];
                           return AnswerTile(
                               isSelected: answer == cubit.selectedAnswer,
                               answer: answer,
                               correctAnswer: currentQuestions.correctAnswer ,
                               onTap:(){
                                 cubit.selectAnswer(answer);
                                 if(answer==currentQuestions.correctAnswer){
                                   cubit.score++;
                                 }
                                 Future.delayed(Duration(milliseconds: 400 ),
                                     (){
                                   if(cubit.currentIndex==widget.questions.length-1)
                                     navigateAndFinish(context, ResultScreen(
                                       questions: widget.questions,
                                       score: cubit.score,
                                     ));
                                   cubit.nextQuestion();
                                     }
                                 );
                               }
                           );
                         },
                           itemCount: currentQuestions.answers!.length,
                         ),
                       ),
                     ],
                   ),
                 ),
             ),
           );
         },
          );
  }
}
class AnswerTile extends StatelessWidget {
  final bool isSelected;
  final String answer;
  final String correctAnswer;
  final Function onTap;

  const AnswerTile({
    Key? key,
    required this.isSelected,
    required this.answer,
    required this.correctAnswer,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50.0), // Adjust the radius as needed
      child: Card(
        color: cardColor,
        child: ListTile(
          onTap: () => onTap(),
          title: Text(
            answer,
            style: TextStyle(
              fontSize: 18,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Color get cardColor {
    if (!isSelected) return Colors.white;

    if (answer == correctAnswer) return Colors.purpleAccent;

    return Colors.redAccent;
  }
}