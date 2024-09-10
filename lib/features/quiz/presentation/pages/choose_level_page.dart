import 'package:flutter/material.dart';
import 'package:football_platform/modules/home/home_screen.dart';
import 'package:football_platform/core/componants/components.dart';
import 'package:football_platform/core/componants/background.dart';

import 'quiz_home_page.dart';


class ChooseLevelPage extends StatelessWidget {
  const ChooseLevelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackGround(
        img: 2,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 120.0),
            child: Column(
              children: [
                Text('Q/A Game',
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
                Text('Choose a level',
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
                actionButton(title: 'Easy',
                    buttonColor: Colors.purple,
                    onTap: (){
                      navigateToWithSlide(context, QuizHomePage(level: 1));

                    }),
                SizedBox(height: 20,),
                actionButton(title: 'Medium',
                    buttonColor: Colors.purple,
                    onTap: (){
                      navigateToWithSlide(context, QuizHomePage(level: 2));

                    }),
                SizedBox(height: 20,),
                actionButton(title: 'Hard',
                    buttonColor: Colors.purple,
                    onTap: (){
                      navigateToWithSlide(context, QuizHomePage(level: 3));
                    }),
                SizedBox(height: 20,),
                actionButton(title: 'Exit',
                    buttonColor: Colors.redAccent,
                    onTap: (){
                      navigateToWithPush(context, HomeScreen());
                    }),
              ],
            ),
          ),
        ),
      ),
    );

  }
}

