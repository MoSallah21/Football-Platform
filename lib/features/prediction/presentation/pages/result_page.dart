import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:football_platform/modules/home/home_screen.dart';
import 'package:football_platform/core/componants/components.dart';
import 'package:hexcolor/hexcolor.dart';


class FinalPredictPage extends StatefulWidget {

 final double prediction;
 final String homeTeam;
 final String homeImg;
 final String awayTeam;
 final String awayImg;
 final String homePos;
 final String awayPos;
 final String homeShoots;
 final String awayShoots;
 final String homeShootsOn;
 final String awayShootsOn;
 final String homeCorner;
 final String awayCorner;
 final String homeChances;
 final String awayChances;


  FinalPredictPage
      ({
    super.key,
    required this.homeTeam,
    required this.homeImg,
    required this.awayTeam,
    required this.awayImg,
    required this.prediction,
    required this.homePos,
    required this.awayPos,
    required this.homeShoots,
    required this.awayShoots,
    required this.homeShootsOn,
    required this.awayShootsOn,
    required this.homeCorner,
    required this.awayCorner,
    required this.homeChances,
    required this.awayChances,

  });



  @override
  State<FinalPredictPage> createState() => _FinalPredictPageState();
}

late Size mediaSize;

class _FinalPredictPageState extends State<FinalPredictPage> {
  late bool isImageVisible;
  late bool isTextVisible;
  late bool isTieVisible;




  @override
  void initState() {
    isImageVisible = false;
    isTextVisible = false;
    isTieVisible= false;
    super.initState();

    Timer(Duration(milliseconds: 3000), () {
      setState(() {
        isImageVisible = true;

      });
    });
    Timer(Duration(milliseconds: 2000), () {
      setState(() {
        isTextVisible = true;

      });
    });
    Timer(Duration(milliseconds: 1000), () {
      setState(() {
        isTieVisible = true;

      });
    });



  }

  @override
  Widget build(BuildContext context) {
    mediaSize = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      backgroundColor: HexColor('#202124'),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child:widget.prediction==0?
        Column(
          children: [
            SizedBox(height: 60,),
            AnimatedOpacity(
              opacity: isTextVisible ? 1.0 : 0.0,
              duration: Duration(milliseconds:1500 ),
              child: Text('${widget.homeTeam}',style: TextStyle(color: Colors.white,fontSize: 34,fontWeight: FontWeight.bold,shadows: [
                Shadow(
                  color: Colors
                      .purpleAccent.shade100,
                  offset: Offset(1,
                      1),
                  blurRadius:
                  1,
                ),
              ],),),
            ),

            AnimatedOpacity(
                opacity: isTieVisible ? 1.0 : 0.0,
                duration: Duration(milliseconds: 800),
                child: Text('Draw ',style: TextStyle(color: Colors.white,fontSize: 34,fontWeight: FontWeight.bold),)),

            AnimatedOpacity(
              opacity: isTextVisible ? 1.0 : 0.0,
              duration: Duration(milliseconds:1500 ),
              child: Text('${widget.awayTeam}',style: TextStyle(color: Colors.white,fontSize: 34,fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors
                        .purpleAccent.shade100,
                    offset: Offset(1,
                        1),
                    blurRadius:
                    1,
                  ),
                ],),),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 150,bottom: 15),
              child: AnimatedOpacity(
                opacity: isImageVisible ? 1.0 : 0.0,
                duration: Duration(milliseconds: 800),
                child: Row(
                  children: [
                    Container(
                      width: 90,height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                          AssetImage('${widget.homeImg}'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 90,height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                          AssetImage('${widget.awayImg}'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: isImageVisible?1.0:0.0,
              duration: Duration(milliseconds: 1500),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('% ${widget.homePos}',style: TextStyle(color: Colors.white,fontSize: 14),),
                          Text('Possession',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14,
                              shadows: [
                                Shadow(
                                  color: Colors
                                      .purpleAccent.shade100,
                                  offset: Offset(1,
                                      1),
                                  blurRadius:
                                  1,
                                ),
                              ]),),
                          Text('% ${widget.awayPos}',style: TextStyle(color: Colors.white,fontSize: 14),),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${widget.homeShoots}',style: TextStyle(color: Colors.white,fontSize: 14),),
                          Text('Shots',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14,
                              shadows: [
                                Shadow(
                                  color: Colors
                                      .purpleAccent.shade100,
                                  offset: Offset(1,
                                      1),
                                  blurRadius:
                                  1,
                                ),
                              ]),),
                          Text('${widget.awayShoots}',style: TextStyle(color: Colors.white,fontSize: 14),),

                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${widget.homeShootsOn}',style: TextStyle(color: Colors.white,fontSize: 14),),
                          Text('Shots on goal',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14,
                              shadows: [
                                Shadow(
                                  color: Colors
                                      .purpleAccent.shade100,
                                  offset: Offset(1,
                                      1),
                                  blurRadius:
                                  1,
                                ),
                              ]),),
                          Text('${widget.awayShootsOn}',style: TextStyle(color: Colors.white,fontSize: 14),),

                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${widget.homeCorner}',style: TextStyle(color: Colors.white,fontSize: 14),),
                          Text('Corners Kick',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14,
                              shadows: [
                                Shadow(
                                  color: Colors
                                      .purpleAccent.shade100,
                                  offset: Offset(1,
                                      1),
                                  blurRadius:
                                  1,
                                ),
                              ]),),
                          Text('${widget.awayCorner}',style: TextStyle(color: Colors.white,fontSize: 14),),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${widget.homeChances}',style: TextStyle(color: Colors.white,fontSize: 14),),
                          Text('Chances',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14,
                              shadows: [
                                Shadow(
                                  color: Colors
                                      .purpleAccent.shade100,
                                  offset: Offset(1,
                                      1),
                                  blurRadius:
                                  1,
                                ),
                              ]),),
                          Text('${widget.awayChances}',style: TextStyle(color: Colors.white,fontSize: 14),),

                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    CircularButton(onPressed: (){}),

                  ],
                ),
              ),
            )

          ],
        ): Column(
          children:
          [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 50),
              child: AnimatedOpacity(
                opacity: isImageVisible ? 1.0 : 0.0,
                duration: Duration(milliseconds: 400),
                child: Container(
                  height: mediaSize.height / 2.5,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                      widget.prediction==-1?AssetImage('${widget.homeImg}'):
                      AssetImage('${widget.awayImg}'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: isImageVisible ? 1.0 : 0.0,
              duration: Duration(milliseconds: 900),
              child: Column(
                children: [
                  Text('Win',style: TextStyle(color: Colors.white,fontSize: 34,fontWeight: FontWeight.bold),),
                  widget.prediction==-1?
                  Text('${widget.homeTeam}',style: TextStyle(color: Colors.white,fontSize: 34,fontWeight: FontWeight.bold,shadows: [
                    Shadow(
                      color: Colors
                          .purpleAccent.shade100,
                      offset: Offset(1,
                          1),
                      blurRadius:
                      1,
                    ),
                  ],),)
                      :
                  Text('${widget.awayTeam}',style: TextStyle(color: Colors.white,fontSize: 34,fontWeight: FontWeight.bold,shadows: [
                    Shadow(
                      color: Colors
                          .purpleAccent.shade100,
                      offset: Offset(1,
                          1),
                      blurRadius:
                      1,
                    ),
                  ],),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(widget.homeImg,height: 200,width: 100,),
                      Text('Vs',style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold),),
                      Image.asset(widget.awayImg,height: 200,width: 100,),


                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('% ${widget.homePos}',style: TextStyle(color: Colors.white,fontSize: 14),),
                              Text('Possession',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14,
                                  shadows: [
                                    Shadow(
                                      color: Colors
                                          .purpleAccent.shade100,
                                      offset: Offset(1,
                                          1),
                                      blurRadius:
                                      1,
                                    ),
                                  ]),),
                              Text('% ${widget.awayPos}',style: TextStyle(color: Colors.white,fontSize: 14),),

                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${widget.homeShoots}',style: TextStyle(color: Colors.white,fontSize: 14),),
                              Text('Shots',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14,
                                  shadows: [
                                    Shadow(
                                      color: Colors
                                          .purpleAccent.shade100,
                                      offset: Offset(1,
                                          1),
                                      blurRadius:
                                      1,
                                    ),
                                  ]),),
                              Text('${widget.awayShoots}',style: TextStyle(color: Colors.white,fontSize: 14),),

                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${widget.homeShootsOn}',style: TextStyle(color: Colors.white,fontSize: 14),),
                              Text('Shots on goal',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14,
                                  shadows: [
                                    Shadow(
                                      color: Colors
                                          .purpleAccent.shade100,
                                      offset: Offset(1,
                                          1),
                                      blurRadius:
                                      1,
                                    ),
                                  ]),),
                              Text('${widget.awayShootsOn}',style: TextStyle(color: Colors.white,fontSize: 14),),

                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${widget.homeCorner}',style: TextStyle(color: Colors.white,fontSize: 14),),
                              Text('Corners Kick',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14,
                                  shadows: [
                                    Shadow(
                                      color: Colors
                                          .purpleAccent.shade100,
                                      offset: Offset(1,
                                          1),
                                      blurRadius:
                                      1,
                                    ),
                                  ]),),
                              Text('${widget.awayCorner}',style: TextStyle(color: Colors.white,fontSize: 14),),

                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${widget.homeChances}',style: TextStyle(color: Colors.white,fontSize: 14),),
                              Text('Chances',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14,
                                  shadows: [
                                    Shadow(
                                      color: Colors
                                          .purpleAccent.shade100,
                                      offset: Offset(1,
                                          1),
                                      blurRadius:
                                      1,
                                    ),
                                  ]),),
                              Text('${widget.awayChances}',style: TextStyle(color: Colors.white,fontSize: 14),),

                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        CircularButton(onPressed: (){
                          navigateAndFinish(context, HomeScreen());
                        }),

                      ],
                    ),
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
