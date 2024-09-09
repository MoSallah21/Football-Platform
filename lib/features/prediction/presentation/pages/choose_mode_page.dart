import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:football_platform/features/prediction/presentation/pages/pick_team_page.dart';
import 'package:football_platform/shared/components/components.dart';

class ChooseModeScreen extends StatelessWidget {
  final List<String> imagePaths = [
    'assets/images/fans.jpg',
    'assets/images/pep.jpg',
  ];

  final List<String> texts = [
    'Fan',
    'Analyst',
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
                navigateToWithSlide(context,PickTeamPage(mode: 1));
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
                navigateToWithSlide(context, PickTeamPage(mode: 2,));

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
