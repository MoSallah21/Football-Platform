import 'dart:async';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/models/items/items.dart';
import 'package:football_platform/modules/predict/predction_screen/possession_screen.dart';
import 'package:football_platform/modules/predict/state_management/predict_cubit.dart';
import 'package:football_platform/modules/predict/state_management/predict_status.dart';
import 'package:football_platform/shared/components/components.dart';
import 'package:hexcolor/hexcolor.dart';

import 'result_screen.dart';

class PickTeam extends StatefulWidget {
  double mode;
   PickTeam({super.key,required this.mode});
  @override
  State<PickTeam> createState() => _PickTeamState();
}

late Size mediaSize;

class _PickTeamState extends State<PickTeam> {
  final PredictCubit cubit = PredictCubit();
  late bool isImageVisible;
  late bool isTextVisible;
  late bool isTeamSelected;
  int? groupValue = 0;
  int? selectedValue = 0;



  @override
  void initState() {
    super.initState();
    isImageVisible = false;
    isTextVisible  = false;
    isTeamSelected = false;

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
  void handleRadioValueChange(int? value) {
    setState(() {
      groupValue = value;
      selectedValue = value ?? 0; // Update the selected value based on the radio button selected, default to 0 if null
    });
    print(selectedValue);
  }
  @override
  Widget build(BuildContext context) {
    mediaSize = MediaQuery.of(context).size;

    return BlocBuilder<PredictCubit,PredictState>(
      bloc: cubit,
      builder: (BuildContext context, Object? state){
        if(cubit.model.homeImg!=''&&cubit.model.awayImg!='')
          Timer(Duration(milliseconds: 600), () {
          setState(() {
            isTeamSelected = true;
          });
        });
        return  Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: HexColor('#202124'),
            body: Column(
              children: [
                AnimatedOpacity(
                  opacity: isImageVisible ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 400),
                  child: Container(
                    height: mediaSize.height / 2.6,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/eps.jpg'),
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
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Text('اختر الفريقان الذين سيتواجهان',style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.w700,
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
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                isExpanded: true,
                                hint:  Row(
                                  children: [
                                    cubit.model.homeTeam==''?Text(
                                      'اختر الفريق المضيف',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              color: Colors
                                                  .purpleAccent.shade100, // Change to the desired purple color
                                              offset: Offset(1,
                                                  1), // Adjust the offset based on your preference
                                              blurRadius:
                                              1, // Adjust the blur radius based on your preference
                                            ),
                                          ]
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ):
                                    Text(
                                      '${cubit.model.homeTeam}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              color: Colors
                                                  .purpleAccent.shade100, // Change to the desired purple color
                                              offset: Offset(1,
                                                  1), // Adjust the offset based on your preference
                                              blurRadius:
                                              1, // Adjust the blur radius based on your preference
                                            ),
                                          ]
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                                items: [
                                  ...cubit.teams.map(
                                        (item) => DropdownMenuItem<MenuItem>(
                                      value: item,
                                      child: buildItem(item),
                                    ),
                                  ),

                                ],
                                onChanged: (value) {
                                  cubit.onChangedHome(context, value! as MenuItem);
                                },
                                buttonStyleData: ButtonStyleData(
                                  height: 50,
                                  width: 160,
                                  padding: const EdgeInsets.only(left: 14, right: 14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: Colors.black26,
                                    ),
                                    color: Color.fromARGB(255, 50, 6, 56),
                                    gradient: const LinearGradient(
                                        colors: [Color(0xFF42275a), Color(0xFF734b6d)]),
                                  ),
                                  elevation: 2,
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: 200,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Color.fromARGB(255, 50, 6, 56),
                                    gradient: const LinearGradient(
                                        colors: [Color(0xFF42275a), Color(0xFF734b6d)]),
                                  ),
                                  offset: const Offset(-20, 0),
                                  scrollbarTheme: ScrollbarThemeData(
                                    radius: const Radius.circular(40),
                                    thickness: MaterialStateProperty.all<double>(6),
                                    thumbVisibility: MaterialStateProperty.all<bool>(true),
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                  padding: EdgeInsets.only(left: 14, right: 14),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                isExpanded: true,
                                hint:  Row(
                                  children: [
                                   cubit.model.awayTeam==''? Text(
                                      'اختر الفريق الضيف',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              color: Colors
                                                  .purpleAccent.shade100, // Change to the desired purple color
                                              offset: Offset(1,
                                                  1), // Adjust the offset based on your preference
                                              blurRadius:
                                              1, // Adjust the blur radius based on your preference
                                            ),
                                          ]
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ):
                                   Text(
                                     '${cubit.model.awayTeam}',
                                     style: TextStyle(
                                         fontSize: 12,
                                         fontWeight: FontWeight.bold,
                                         color: Colors.white,
                                         shadows: [
                                           Shadow(
                                             color: Colors
                                                 .purpleAccent.shade100, // Change to the desired purple color
                                             offset: Offset(1,
                                                 1), // Adjust the offset based on your preference
                                             blurRadius:
                                             1, // Adjust the blur radius based on your preference
                                           ),
                                         ]
                                     ),
                                     overflow: TextOverflow.ellipsis,
                                   ),
                                  ],
                                ),
                                items: [
                                  ...cubit.teams.map(
                                        (item) => DropdownMenuItem<MenuItem>(
                                      value: item,
                                      child: buildItem(item),
                                    ),
                                  ),

                                ],
                                onChanged: (value) {
                                  cubit.onChangedAway(context, value! as MenuItem);
                                },
                                buttonStyleData: ButtonStyleData(
                                  height: 50,
                                  width: 160,
                                  padding: const EdgeInsets.only(left: 14, right: 14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: Colors.black26,
                                    ),
                                    color: Color.fromARGB(255, 50, 6, 56),
                                    gradient: const LinearGradient(
                                        colors: [Color(0xFF42275a), Color(0xFF734b6d)]),
                                  ),
                                  elevation: 2,
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: 200,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Color.fromARGB(255, 50, 6, 56),
                                    gradient: const LinearGradient(
                                        colors: [Color(0xFF42275a), Color(0xFF734b6d)]),
                                  ),
                                  offset: const Offset(-20, 0),
                                  scrollbarTheme: ScrollbarThemeData(
                                    radius: const Radius.circular(40),
                                    thickness: MaterialStateProperty.all<double>(6),
                                    thumbVisibility: MaterialStateProperty.all<bool>(true),
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                  padding: EdgeInsets.only(left: 14, right: 14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      if(cubit.model.homeImg!=''&&cubit.model.awayImg!='')
                      AnimatedOpacity(
                        opacity: isTeamSelected ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 400),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal:75,vertical: 15),
                          child: Row(
                            children: [
                              Container(
                                width: 80,height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(image: AssetImage('${cubit.model.homeImg}'))
                                ),
                              ),
                              Spacer(),
                              Text('ضد',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                              Spacer(),
                              AnimatedOpacity(
                                duration: Duration(milliseconds: 400),
                                opacity: isTeamSelected ? 1.0 : 0.0,
                                child: Container(
                                  width: 80,height: 80,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image:
                                        AssetImage('${cubit.model.awayImg}'

                                        ),)
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),


                    ],
                  ),
                ),
                SizedBox(height: 50,),
                  CircularButton(onPressed: () async {
                    if(cubit.model.homeTeam==''||cubit.model.awayTeam=='')
                    {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('يرجى ادخال فريقين لتوقع النتيجة بينهما'),
                        duration: Duration(seconds: 3),
                      ),);

                    }
                    else if(cubit.model.homeTeam==cubit.model.awayTeam){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('يرجى ادخال فريقين مختلفين لتوقع النتيجة بينهما'),
                        duration: Duration(seconds: 3),
                      ),);

                    }
                    else{
                      if(widget.mode==1){
                        Map<String, dynamic> prediction = await cubit.predictResults(
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
                        );
                        double predictionValue = prediction['prediction'][0][0].toDouble();
                        print(predictionValue);
                        navigateToWithSlide(context,
                            FinalPredictScreen(
                              homeTeam: cubit.model.homeTeam,
                              awayTeam: cubit.model.awayTeam,
                              homeImg: cubit.model.homeImg,
                              awayImg: cubit.model.awayImg,
                              prediction: predictionValue,
                              homePos:prediction['pr'][0][1].toStringAsFixed(2),
                              homeShoots: prediction['pr'][0][2].toStringAsFixed(2),
                              homeCorner:prediction['pr'][0][3].toStringAsFixed(2) ,
                              homeShootsOn: prediction['pr'][0][4].toStringAsFixed(2),
                              homeChances:prediction['pr'][0][5].toStringAsFixed(2) ,
                              awayPos: prediction['pr'][0][7].toStringAsFixed(2),
                              awayShoots: prediction['pr'][0][8].toStringAsFixed(2),
                              awayCorner:prediction['pr'][0][9].toStringAsFixed(2),
                              awayShootsOn: prediction['pr'][0][10].toStringAsFixed(2),
                              awayChances:prediction['pr'][0][11].toStringAsFixed(2) ,



                            )
                        );
                      }
                       else if(cubit.model.homeTeam==cubit.model.awayTeam){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('يرجى ادخال فريقين مختلفين لتوقع النتيجة بينهما'),
                          duration: Duration(seconds: 3),
                        ),);

                      }
                      else if(widget.mode==2&&selectedValue==2){
                      navigateToWithSlide(context,
                          PosScreen(
                            mode: 2,
                            homeTeam: cubit.model.homeTeam,
                            awayTeam: cubit.model.awayTeam,
                            homeImg: cubit.model.homeImg,
                            awayImg: cubit.model.awayImg,
                            homeCode: cubit.model.homeCode,
                            awayCode: cubit.model.awayCode,
                            homeAvgShoots: cubit.model.meanHomeShoots,
                            homeAvgShootsOn: cubit.model.meanHomeShOnTarget,
                            homeAvgChances: cubit.model.meanHomeCh,
                            homeAvgCorners: cubit.model.meanHomeCor,
                            awayAvgShoots: cubit.model.meanAwayShoots,
                            awayAvgShootsOn: cubit.model.meanAwayShOnTarget,
                            awayAvgCorners: cubit.model.meanAwayCor,
                            awayAvgChances: cubit.model.meanAwayCh,
                          ));}
                      else if(widget.mode==2&&selectedValue==3){
                        navigateToWithSlide(context,
                            PosScreen(
                              mode: 3,
                              homeTeam: cubit.model.homeTeam,
                              awayTeam: cubit.model.awayTeam,
                              homeImg: cubit.model.homeImg,
                              awayImg: cubit.model.awayImg,
                              homeCode: cubit.model.homeCode,
                              awayCode: cubit.model.awayCode,
                              homeAvgShoots: cubit.model.meanHomeShoots,
                              homeAvgShootsOn: cubit.model.meanHomeShOnTarget,
                              homeAvgChances: cubit.model.meanHomeCh,
                              homeAvgCorners: cubit.model.meanHomeCor,
                              awayAvgShoots: cubit.model.meanAwayShoots,
                              awayAvgShootsOn: cubit.model.meanAwayShOnTarget,
                              awayAvgCorners: cubit.model.meanAwayCor,
                              awayAvgChances: cubit.model.meanAwayCh,
                            ));
                      }}
                  }),
                if(widget.mode!=1)
                SizedBox(height: 30,),
                if(widget.mode!=1)
                  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio(
                      value: 2,
                      activeColor: Colors.purple, // Change color when selected
                      fillColor: MaterialStateColor.resolveWith((states) =>
                      states.contains(MaterialState.selected)
                          ? Colors.purple
                          : Colors.purple.shade200),
                      groupValue: groupValue,
                      onChanged: handleRadioValueChange,
                    ),
                    Text('تاثير جزئي',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                    Radio(
                      value: 3,
                      activeColor: Colors.purple, // Change color when selected
                      fillColor: MaterialStateColor.resolveWith((states) =>
                      states.contains(MaterialState.selected)
                          ? Colors.purple
                          : Colors.purple.shade200),
                      groupValue: groupValue,
                      onChanged: handleRadioValueChange,
                    ),
                    Text('تاثير كامل',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16)),
                    SizedBox(width: 50,),

                  ],
                ),

              ],
            )
          ),
        );
      }

    );
  }
  Widget buildItem(MenuItem item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            item.icon!,
            Spacer(),
            Text(
              item.text,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
        SizedBox(height: 5,),
        Container(
          width: 150,
          height: 1,
          color: Colors.white.withOpacity(0.6),
        )
      ],
    );
  }
}



