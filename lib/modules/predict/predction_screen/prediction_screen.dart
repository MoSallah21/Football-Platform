import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/modules/predict/predction_screen/choose_mode_screen.dart';
import 'package:football_platform/modules/predict/predction_screen/pick_team_screen.dart';
import 'package:football_platform/modules/predict/state_management/predict_cubit.dart';
import 'package:football_platform/modules/predict/state_management/predict_status.dart';
import 'package:football_platform/shared/components/components.dart';
import 'package:hexcolor/hexcolor.dart';

class MatchPredict extends StatefulWidget {
  const MatchPredict({super.key});

  @override
  State<MatchPredict> createState() => _MatchPredictState();
}

late Size mediaSize;

class _MatchPredictState extends State<MatchPredict> {
  final PredictCubit cubit = PredictCubit();
  late bool isImageVisible;
  late bool isTextVisible;

  @override
  void initState() {
    super.initState();
    isImageVisible = false;
    isTextVisible  = false;

    // Add a delay before showing the first Container (image)
    Timer(Duration(milliseconds: 500), () {
      setState(() {
        isImageVisible = true;
      });
    });
    Timer(Duration(seconds: 1), () {
      setState(() {
        isTextVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    mediaSize = MediaQuery.of(context).size;
    return BlocConsumer<PredictCubit,PredictState>(
        listener: (context,state){},
     builder: (BuildContext context, Object? state){
       return Directionality(
         textDirection: TextDirection.rtl,
         child: Scaffold(
           backgroundColor: HexColor('#202124'),
           body: Column(
             children: [
               AnimatedOpacity(
                 opacity: isImageVisible ? 1.0 : 0.0,
                 duration: Duration(milliseconds: 400),
                 child: Container(
                   height: mediaSize.height / 1.4,
                   decoration: BoxDecoration(
                     image: DecorationImage(
                       image: AssetImage('assets/images/img.png'),
                       colorFilter: ColorFilter.mode(
                         Colors.purpleAccent.withOpacity(0.75),
                         BlendMode.dstATop,
                       ),
                       fit: BoxFit.cover,
                     ),
                   ),
                 ),
               ),
               AnimatedOpacity(
                 opacity: isTextVisible ? 1.0 : 0.0,
                 duration: Duration(milliseconds: 900),
                 child: Padding(
                   padding: const EdgeInsets.all(15.0),
                   child: Text('ماهي نتيجة الجولة القادمة في الدوري الانكليزي ؟ هل يمكن معرفة اذا كان فريقك سيفوز او يخسر في الجولة القادمة ؟  عن طريق الاحصائيات التي تتوقعها ؟',style: TextStyle(fontSize: 19,color: Colors.white,fontWeight: FontWeight.w700,shadows: [
                     Shadow(
                       color: Colors
                           .purpleAccent.shade100, // Change to the desired purple color
                       offset: Offset(1,
                           1), // Adjust the offset based on your preference
                       blurRadius:
                       1, // Adjust the blur radius based on your preference
                     ),
                   ],),),
                 ),
               ),
               CircularButton(onPressed: (){
                 navigateToWithSlide(context, ChooseModeScreen());
               }),

             ],
           )
         ),
       );
     },
    );
  }
}

