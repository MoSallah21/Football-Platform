import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:football_platform/modules/about_football/blogs/blogs.dart';
import 'package:football_platform/modules/about_football/quiz/choose_level/choose_level.dart';
import 'package:football_platform/shared/components/components.dart';

class AboutFootBallScreen extends StatelessWidget {
  final List<String> imagePaths = [
    'assets/images/kdb.jpg',
    'assets/images/shotss.jpg', // Add more image paths here
  ];

  final List<String> texts = [
    'العاب',
    'مقالات', // Add corresponding texts here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            InkWell(
              onTap: () {
                navigateToWithSlide(context, ChooseLevel());
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePaths[0]),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
                  ),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.purpleAccent.withOpacity(0.1),
                    ),
                    child: Center(
                      child: Text(
                        texts[0],
                        textAlign: TextAlign.center,
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
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                navigateToWithSlide(context, BlogsScreen());

              },

              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePaths[1]),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),

                  ),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.purpleAccent.withOpacity(0.1),
                    ),
                    child: Center(
                      child: Text(
                        texts[1],
                        textAlign: TextAlign.center,
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
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
