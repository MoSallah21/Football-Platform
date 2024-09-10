import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/features/prediction/presentation/bloc/predict_bloc.dart';
import 'package:football_platform/core/componants/components.dart';
import 'package:hexcolor/hexcolor.dart';

import 'result_page.dart';


class CornersChancesPage extends StatefulWidget {
final  double mode;
final  String homeTeam;
final  String awayTeam;
final  String homeImg;
final  String awayImg;
final  double homePos;
final  double awayPos;
final  double homeShoots;
final  double awayShoots;
final  double homeShootsOn;
final  double awayShootsOn;
final  double homeCode;
final  double awayCode;
final  double homeAvgCorners;
final  double homeAvgChances;
final  double awayAvgCorners;
final  double awayAvgChances;

  CornersChancesPage({
    super.key,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeImg,
    required this.awayImg,
    required this.homePos,
    required this.awayPos,
    required this.homeShoots,
    required this.awayShoots,
    required this.homeShootsOn,
    required this.awayShootsOn,
    required this.homeCode,
    required this.awayCode,
    required this.homeAvgCorners,
    required this.awayAvgCorners,
    required this.homeAvgChances,
    required this.awayAvgChances,
    required this.mode,
  }
      );

  @override
  State<CornersChancesPage> createState() => _CornersChancesPageState();
}

late Size mediaSize;

class _CornersChancesPageState extends State<CornersChancesPage> {
  late bool isImageVisible;
  TextEditingController homeCornersController=TextEditingController();
  TextEditingController awayCornersController=TextEditingController();
  TextEditingController homeChancesOnController=TextEditingController();
  TextEditingController awayChancesOnController=TextEditingController();
  bool? isHomeCornersMean=false;
  bool? isAwayCornersMean=false;
  bool? isHomeChancesMean=false;
  bool? isAwayChancesMean=false;


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

    return BlocConsumer<PredictBloc,PredictState>(
      builder: (BuildContext context, PredictState state) {
        var cubit=PredictBloc.get(context);
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
                        image: AssetImage('assets/images/liverpool.jpg'),
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
                  padding: const EdgeInsets.symmetric(vertical: 25.0,horizontal: 10),
                  child: Text('What you predict about corner kick and chances',style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w700,
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
                              value: isHomeCornersMean,
                              onChanged: ( isMean) {
                                setState(() {
                                  isHomeCornersMean=isMean;
                                  if(isHomeCornersMean!){
                                    homeCornersController.text=widget.homeAvgCorners.toInt().toString();
                                  }
                                  if(!isHomeCornersMean!)
                                    homeCornersController.text="";

                                });
                              },
                              side: BorderSide(color: Colors.white), // Change this to the desired border color

                              activeColor: Colors.purple,
                              checkColor: Colors.black,
                            ),
                            SizedBox(height: 35,),

                            Checkbox(
                              value: isHomeChancesMean,
                              onChanged: ( isMean) {
                                setState(() {
                                  isHomeChancesMean=isMean;
                                  if(isHomeChancesMean!){
                                    homeChancesOnController.text=widget.homeAvgChances.toInt().toString();
                                  }
                                  if(!isHomeChancesMean!)
                                    homeChancesOnController.text="";


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
                                controller:homeCornersController ,
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
                                controller: homeChancesOnController,
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
                              'Corner Kick',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),                              SizedBox(height: 50,),
                          Text('Chances',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),

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
                                controller: awayCornersController,
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
                                controller: awayChancesOnController,
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
                              value: isAwayCornersMean,
                              onChanged: ( isMean) {
                                setState(() {
                                  isAwayCornersMean=isMean;
                                  if(isAwayCornersMean!){
                                    awayCornersController.text=widget.awayAvgCorners.toInt().toString();
                                  }
                                  if(!isAwayCornersMean!)
                                    awayCornersController.text="";

                                });
                              },
                              side: BorderSide(color: Colors.white), // Change this to the desired border color

                              activeColor: Colors.purple,
                              checkColor: Colors.black,
                            ),
                            SizedBox(height: 35,),

                            Checkbox(
                              value: isAwayChancesMean,
                              onChanged: ( isMean) {
                                setState(() {
                                  isAwayChancesMean=isMean;
                                  if(isAwayChancesMean!){
                                    awayChancesOnController.text=widget.awayAvgChances.toInt().toString();
                                  }
                                  if(!isAwayChancesMean!)
                                    awayChancesOnController.text="";
                                });
                              },
                              side: BorderSide(color: Colors.white),

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
                CircularButton(onPressed: ()async{
                  print(widget.mode);
                  if(homeCornersController.text==''||homeChancesOnController.text==''||awayCornersController.text==''||awayChancesOnController.text=='')
                  {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Enter all value for both teams'),
                      duration: Duration(seconds: 3),
                    ),);

                  }
                  else if(double.parse(homeCornersController.text)>18||double.parse(awayCornersController.text)>18||double.parse(homeCornersController.text)<0||double.parse(awayCornersController.text)<0)
                  {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Please enter a real value in corners for both teams'),
                      duration: Duration(seconds: 3),
                    ),);

                  }
                  else if(double.parse(homeChancesOnController.text)>7||double.parse(awayChancesOnController.text)>6||double.parse(homeChancesOnController.text)<0||double.parse(awayChancesOnController.text)<0)
                  {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Please enter a real value in chances for both teams'),
                      duration: Duration(seconds: 3),
                    ),);
                  }
                  else{
                    cubit.add(PredictResultEvent(
                      mode: 1,
                      homeCode: cubit.model.homeCode,
                      awayCode: cubit.model.awayCode,
                      homePoss: 0,
                      awayPoss: 0,
                      homeCorners: 0,
                      awayChances: 0,
                      awayCorners: 0,
                      homeChances: 0,
                      homeShootsOn: 0,
                      homeShoots: 0,
                      awayShoots: 0,
                      awayShootsOn: 0,
                    ));
                  }
                }),
              ],
            ),
          ),
        );
      }, listener: (BuildContext context, PredictState state) async {
      var cubit=PredictBloc.get(context);
      if (state is PredictResultSuccessState) {
        double predictionValue = state.result['prediction'][0][0].toDouble();
        navigateToWithSlide(context, FinalPredictPage(
          homeTeam: cubit.model.homeTeam,
          awayTeam: cubit.model.awayTeam,
          homeImg: cubit.model.homeImg,
          awayImg: cubit.model.awayImg,
          prediction: predictionValue,
          homePos: state.result['pr'][0][1].toStringAsFixed(2),
          homeShoots: state.result['pr'][0][2].toStringAsFixed(2),
          homeCorner: state.result['pr'][0][3].toStringAsFixed(2),
          homeShootsOn: state.result['pr'][0][4].toStringAsFixed(2),
          homeChances: state.result['pr'][0][5].toStringAsFixed(2),
          awayPos: state.result['pr'][0][7].toStringAsFixed(2),
          awayShoots: state.result['pr'][0][8].toStringAsFixed(2),
          awayCorner: state.result['pr'][0][9].toStringAsFixed(2),
          awayShootsOn: state.result['pr'][0][10].toStringAsFixed(2),
          awayChances: state.result['pr'][0][11].toStringAsFixed(2),
        ));
        final player = AudioPlayer();
        await player.play(AssetSource('sounds/crawd.mp3'));
      }
    },
    );
  }
}
