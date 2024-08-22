import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/modules/about_football/quiz/quiz_home_screen/quiz_home.dart';
import 'package:football_platform/modules/about_football/state_management/about_cubit.dart';
import 'package:football_platform/modules/about_football/state_management/about_state.dart';
import 'package:football_platform/modules/home/home_screen.dart';
import 'package:football_platform/shared/components/components.dart';
import 'package:football_platform/shared/components/background.dart';


class ChooseLevel extends StatelessWidget {
  const ChooseLevel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AboutCubit,AboutState>(
      listener: (BuildContext context, state) {  },
      builder: (BuildContext context, Object? state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: BackGround(
              img: 2,
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
                      Text('اختر مستوى',
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
                     actionButton(title: 'سهل',
                     buttonColor: Colors.purple,
                     onTap: (){
                       navigateToWithSlide(context, QuizHome(level: 1));

                     }),
                     SizedBox(height: 20,),
                      actionButton(title: 'متوسط',
                          buttonColor: Colors.purple,
                          onTap: (){
                            navigateToWithSlide(context, QuizHome(level: 2));

                          }),
                      SizedBox(height: 20,),
                      actionButton(title: 'صعب',
                          buttonColor: Colors.purple,
                          onTap: (){
                            navigateToWithSlide(context, QuizHome(level: 3));
                          }),
                      SizedBox(height: 20,),
                       actionButton(title: 'خروج',
                       buttonColor: Colors.redAccent,
                       onTap: (){
                         navigateToWithPush(context, HomeScreen());
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

