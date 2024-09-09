import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:football_platform/features/prediction/presentation/pages/shoots_page.dart';
import 'package:football_platform/shared/components/components.dart';
import 'package:hexcolor/hexcolor.dart';

class PossessionPage extends StatefulWidget {

   PossessionPage({
     super.key,
     required this.mode,
     required this.homeTeam,
     required this.awayTeam,
     required this.homeImg,
     required this.awayImg,
     required this.homeCode,
     required this.awayCode,
     required this.homeAvgShoots,
     required this.homeAvgShootsOn,
     required this.awayAvgShoots,
     required this.awayAvgShootsOn,
     required this.homeAvgCorners,
     required this.awayAvgCorners,
     required this.homeAvgChances,
     required this.awayAvgChances,




   });
   final  double mode;
   final  String homeTeam;
   final  String awayTeam;
   final  String homeImg;
   final  String awayImg;
   final  double homeCode;
   final  double awayCode;
   final  double homeAvgShoots;
   final  double homeAvgShootsOn;
   final  double awayAvgShoots;
   final  double awayAvgShootsOn;
   final  double homeAvgCorners;
   final  double homeAvgChances;
   final  double awayAvgCorners;
   final  double awayAvgChances;




   @override
  State<PossessionPage> createState() => _PossessionPageState();
}

late Size mediaSize;

class _PossessionPageState extends State<PossessionPage> {
  late bool isImageVisible;
  TextEditingController homePosController=TextEditingController();
  TextEditingController awayPosController=TextEditingController();
  @override
  void initState() {
    isImageVisible = false;
    super.initState();
    Timer(Duration(milliseconds: 500), () {
      setState(() {
        isImageVisible = true;
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
        child: Column(
          children: [
            AnimatedOpacity(
              opacity: isImageVisible ? 1.0 : 0.0,
              duration: Duration(milliseconds: 400),
              child: Container(
                height: mediaSize.height / 2.2,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/ball.jpg'),
                    colorFilter: ColorFilter.mode(
                      Colors.purpleAccent.withOpacity(0.7),
                      BlendMode.dstATop,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              child: Text('What a Percent of ball possession for both teams ?',style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w700,
                shadows: [
                  Shadow(
                    color: Colors
                        .purpleAccent.shade100,
                    offset: Offset(1,
                        1),
                    blurRadius:
                    1,
                  ),
                ],
              )

              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:75,vertical: 15),
              child: Row(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right:15.0),
                        child: Container(
                          width: 80,height: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(image: AssetImage('${widget.homeImg}'))
                          ),
                        ),
                      ),
                      SizedBox(height: 2,),
                      Padding(
                        padding: const EdgeInsets.only(right:15.0),
                        child: Text('Home',style: TextStyle(color: Colors.white,shadows: [
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
                      SizedBox(height: 20,),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text('%',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
                          ),
                          SizedBox(
                            height: mediaSize.height / 15,
                            width: mediaSize.width / 6,
                            child: Container(
                              height: mediaSize.height / 15,
                              width: mediaSize.width / 12,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: TextField(
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                                cursorColor: Colors.purpleAccent.shade100,
                                decoration: InputDecoration(
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                ),
                                controller:homePosController ,
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(5), // Set total character limit
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d{0,2}$'),

                                    // Allow digits, optional decimal point, and at most one digit after it
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),


                  Spacer(),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Container(
                          width: 80,height: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(image: AssetImage('${widget.awayImg}'))
                          ),
                        ),
                      ),
                      SizedBox(height: 2,),
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Text('Away',style: TextStyle(color: Colors.white,shadows: [
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
                      SizedBox(height: 20,),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text('%',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
                          ),
                          SizedBox(
                            height: mediaSize.height / 15,
                            width: mediaSize.width / 6,
                            child: Container(
                              height: mediaSize.height / 15,
                              width: mediaSize.width / 12,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: TextField(
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                                cursorColor: Colors.purpleAccent.shade100,
                                controller: awayPosController,
                                decoration: InputDecoration(
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                ),
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(5), // Set total character limit
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d{0,2}$'),
                                    // Allow digits, optional decimal point, and at most one digit after it
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 25,),
            CircularButton(onPressed: (){
              if(homePosController.text ==''||awayPosController.text =='')
              {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Please enter a ball possession value for both teams'),
                  duration: Duration(seconds: 4),
                ),);
              }
              else if(double.parse(homePosController.text)>=83||double.parse(awayPosController.text)>=83)
              {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Please enter a real value for ball possession'),
                  duration: Duration(seconds: 3),
                ),);

              }
              else
                navigateToWithSlide(context,
                    ShootsPage(
                      mode: widget.mode,
                      homeTeam: widget.homeTeam,
                      homeImg: widget.homeImg,
                      homePos: double.parse(homePosController.text),
                      awayTeam: widget.awayTeam,
                      awayImg: widget.awayImg,
                      awayPos: double.parse(awayPosController.text),
                      homeCode: widget.homeCode,
                      awayCode: widget.awayCode,
                      homeAvgShoots: widget.homeAvgShoots,
                      homeAvgShootsOn: widget.homeAvgShootsOn,
                      homeAvgChances: widget.homeAvgChances,
                      homeAvgCorners: widget.homeAvgCorners,
                      awayAvgShoots: widget.awayAvgShoots,
                      awayAvgShootsOn: widget.awayAvgShootsOn,
                      awayAvgCorners: widget.awayAvgCorners,
                      awayAvgChances: widget.awayAvgChances,
                    )
                );
            }),
          ],
        ),
      ),
    );

  }
  }
