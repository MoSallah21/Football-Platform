import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/features/prediction/presentation/pages/coreners_chances_page.dart';
import 'package:football_platform/core/componants/components.dart';
import 'package:hexcolor/hexcolor.dart';

class ShootsPage extends StatefulWidget {
final  double mode;
final  String homeTeam;
final  String awayTeam;
final  String homeImg;
final  String awayImg;
final  double homePos;
final  double awayPos;
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


  ShootsPage({
    super.key,
    required this.mode,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeImg,
    required this.awayImg,
    required this.homePos,
    required this.awayPos,
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


  @override
  State<ShootsPage> createState() => _ShootsPageState();
}

late Size mediaSize;

class _ShootsPageState extends State<ShootsPage> {
  late bool isImageVisible;
  TextEditingController homeShootsController=TextEditingController();
  TextEditingController awayShootsController=TextEditingController();
  TextEditingController homeShootsOnController=TextEditingController();
  TextEditingController awayShootsOnController=TextEditingController();
  bool? isHomeShotsMean=false;
  bool? isAwayShotsMean=false;
  bool? isHomeShotsOnMean=false;
  bool? isAwayShotsOnMean=false;

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
        physics:BouncingScrollPhysics(),
        child: Column(
          children: [
            AnimatedOpacity(
              opacity: isImageVisible ? 1.0 : 0.0,
              duration: Duration(milliseconds: 400),
              child: Container(
                height: mediaSize.height / 2.2,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/erling_haaland.jpg'),
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
              child: Text('How many shots do you expect for each team?',style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w700,
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
              padding: const EdgeInsets.symmetric(horizontal:30,vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 135.0),
                    child: Column(
                      children: [
                        Checkbox(
                          value: isHomeShotsMean,
                          onChanged: ( isMean) {
                            setState(() {
                              isHomeShotsMean=isMean;
                              if(isHomeShotsMean!){
                                homeShootsController.text=widget.homeAvgShoots.toInt().toString();
                              }
                              if(!isHomeShotsMean!)
                                homeShootsController.text="";


                            });
                          },
                          side: BorderSide(color: Colors.white), // Change this to the desired border color

                          activeColor: Colors.purple,
                          checkColor: Colors.black,
                        ),
                        SizedBox(height: 35,),

                        Checkbox(
                          value: isHomeShotsOnMean,
                          onChanged: ( isMean) {
                            setState(() {
                              isHomeShotsOnMean=isMean;
                              if(isHomeShotsOnMean!){
                                homeShootsOnController.text=widget.homeAvgShootsOn.toInt().toString();
                              }
                              if(!isHomeShotsOnMean!)
                                homeShootsOnController.text="";


                            });
                          },
                          side: BorderSide(color: Colors.white), // Change this to the desired border color

                          activeColor: Colors.purple,
                          checkColor: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        width: 80,height: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(image: AssetImage('${widget.homeImg}'))
                        ),
                      ),
                      SizedBox(height: 2,),
                      Text('Home',style: TextStyle(color: Colors.white,shadows: [
                        Shadow(
                          color: Colors
                              .purpleAccent.shade100,
                          offset: Offset(1,
                              1),
                          blurRadius:
                          1,
                        ),
                      ],),),
                      SizedBox(height: 20,),
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
                            controller: homeShootsController,
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
                      SizedBox(height: 30,),
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
                            controller: homeShootsOnController,
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
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 124), // Add padding here
                        child: Text(
                          'Total',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),                              SizedBox(height: 50,),
                      Text('On goal',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),

                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 80,height: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(image: AssetImage('${widget.awayImg}'))
                        ),
                      ),
                      SizedBox(height: 2,),
                      Text('Away',style: TextStyle(color: Colors.white,shadows: [
                        Shadow(
                          color: Colors
                              .purpleAccent.shade100,
                          offset: Offset(1,
                              1),
                          blurRadius:
                          1,
                        ),
                      ],),),
                      SizedBox(height: 20,),
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
                            controller: awayShootsController,
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
                      SizedBox(height: 30,),
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
                            controller: awayShootsOnController,
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
                  Padding(
                    padding: const EdgeInsets.only(top: 135.0),
                    child: Column(
                      children: [
                        Checkbox(
                          value: isAwayShotsMean,
                          onChanged: ( isMean) {
                            setState(() {
                              isAwayShotsMean=isMean;
                              if(isAwayShotsMean!){
                                awayShootsController.text=widget.awayAvgShoots.toInt().toString();
                              }
                              if(!isAwayShotsMean!)
                                awayShootsController.text="";
                            });
                          },
                          side: BorderSide(color: Colors.white), // Change this to the desired border color

                          activeColor: Colors.purple,
                          checkColor: Colors.black,
                        ),
                        SizedBox(height: 35,),

                        Checkbox(
                          value: isAwayShotsOnMean,
                          onChanged: ( isMean) {
                            setState(() {
                              isAwayShotsOnMean=isMean;
                              if(isAwayShotsOnMean!){
                                awayShootsOnController.text=widget.awayAvgShootsOn.toInt().toString();
                              }
                              if(!isAwayShotsOnMean!)
                                awayShootsOnController.text="";


                            });
                          },
                          side: BorderSide(color: Colors.white), // Change this to the desired border color

                          activeColor: Colors.purple,
                          checkColor: Colors.black,
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
            SizedBox(height: 25,),
            CircularButton(onPressed: (){
              if(homeShootsController.text==''||homeShootsOnController.text=='' || awayShootsController.text==''|| awayShootsOnController.text=='')
              {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Please enter all values for each team to predict the outcome between them.'),
                  duration: Duration(seconds: 3),
                ),);

              }
              else if(double.parse(homeShootsController.text)>34||double.parse(awayShootsController.text)>32 ||double.parse(homeShootsController.text)<1||double.parse(awayShootsController.text)<1)
              {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('The payment values fpr not realistic values, please adjust them according to reality.'),
                  duration: Duration(seconds: 3),
                ),);

              }
              else if(double.parse(homeShootsController.text)<double.parse(homeShootsOnController.text) || double.parse(awayShootsController.text)<double.parse(awayShootsOnController.text))
              {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('The total number of shots cannot be less than the number of shots on goal'),
                  duration: Duration(seconds: 3),
                ),);
              }
              else
                navigateToWithSlide(context,
                    CornersChancesPage(
                      mode: widget.mode,
                      homeTeam:widget.homeTeam ,
                      homeImg:widget.homeImg ,
                      homePos:widget.homePos ,
                      homeShoots:double.parse(homeShootsController.text) ,
                      homeShootsOn:double.parse(homeShootsOnController.text),
                      awayTeam:widget.awayTeam ,
                      awayImg:widget.awayImg ,
                      awayPos:widget.awayPos ,
                      awayShoots:double.parse(awayShootsController.text),
                      homeCode: widget.homeCode,
                      awayCode: widget.awayCode,
                      awayShootsOn:double.parse(awayShootsOnController.text),
                      homeAvgChances: widget.homeAvgChances,
                      homeAvgCorners: widget.homeAvgCorners,
                      awayAvgCorners: widget.awayAvgCorners,
                      awayAvgChances: widget.awayAvgChances,

                    ));

            }),
          ],
        ),
      ),
    );
  }
}
