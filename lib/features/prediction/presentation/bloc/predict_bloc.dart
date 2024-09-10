import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/core/errors/failures.dart';
import 'package:football_platform/core/strings/failures.dart';
import 'package:football_platform/features/prediction/data/models/team_prediction_model.dart';
import 'package:football_platform/features/prediction/domain/usecases/predict_result.dart';
import 'package:football_platform/core/utl/items.dart';
part 'predict_event.dart';
part 'predict_state.dart';
class PredictBloc extends Bloc<PredictEvent, PredictState> {
  static PredictBloc get(context) => BlocProvider.of(context);
 late List<MenuItem> _teams ;

  final PredictUseCase predict;

  PredictBloc({required this.predict}) : super(PredictInitState()) {
    on<PredictResultEvent>((event, emit) async {
      emit(PredictResultLoadingState());

      final failureOrResult = await predict.call(
        mode: event.mode,
        homeCode: event.homeCode,
        awayCode: event.awayCode,
        homeShootsOn: event.homeShootsOn = null ?? 0,
        awayShootsOn: event.awayShootsOn = null ?? 0,
        homeShoots: event.homeShoots = null ?? 0,
        awayShoots: event.awayShoots = null ?? 0,
        homePoss: event.homePoss = null ?? 0,
        awayPoss: event.awayPoss = null ?? 0,
        homeCorners: event.homeCorners = null ?? 0,
        awayCorners: event.awayCorners = null ?? 0,
        homeChances: event.homeChances = null ?? 0,
        awayChances: event.awayChances = null ?? 0,
      );
      failureOrResult.fold(
            (failure) => emit(PredictResultErrorState(message: _mapFailureToMessage(failure))),
            (result) => emit(PredictResultSuccessState(result: result)),
      );
    }

    );



    _teams=getTeamsList();

  }
  List<MenuItem> get teams => _teams;

  List<MenuItem> getTeamsList() {
    return [
      man_city,
      liverpool,
      arsenal,
      man_united,
      tottenham,
      chelsea,
      brighton,
      new_castle,
      west_ham,
      nottingham_forest,
      crystal_palace,
      fulham,
      burnley,
      wolves,
      brentford,
      everton,
      sheffield_united,
      bournemouth,
      aston_villa,
    ];
  }
  static const man_city = MenuItem(text: 'MCY', icon: Image(image: AssetImage('assets/images/clubs/manchester_city.png',),width: 60,height: 30,));
  static const liverpool =MenuItem(text: 'LIV', icon: Image(image: AssetImage('assets/images/clubs/liverpool_fc.png',),width: 60,height: 30,));
  static const arsenal =MenuItem(text: 'ARS', icon: Image(image: AssetImage('assets/images/clubs/arsenal_fc.png',),width: 60,height: 30,));
  static const man_united =MenuItem(text: 'MNU', icon: Image(image: AssetImage('assets/images/clubs/manchester_united.png',),width: 60,height: 30,));
  static const tottenham =MenuItem(text: 'TOT', icon: Image(image: AssetImage('assets/images/clubs/tottenham_hotspur.png',),width: 60,height: 30,));
  static const chelsea =MenuItem(text: 'CHE', icon: Image(image: AssetImage('assets/images/clubs/chelsea_fc.png',),width: 60,height: 30,));
  static const brighton =MenuItem(text: 'BRI', icon: Image(image: AssetImage('assets/images/clubs/brighton.png',),width: 60,height: 30,));
  static const new_castle =MenuItem(text: 'NSTL', icon: Image(image: AssetImage('assets/images/clubs/new_castle.png',),width: 60,height: 30,));
  static const west_ham =MenuItem(text: 'WST', icon: Image(image: AssetImage('assets/images/clubs/west_ham_united.png',),width: 60,height: 30,));
  static const nottingham_forest =MenuItem(text: 'NOTF', icon: Image(image: AssetImage('assets/images/clubs/nottingham_forest.png',),width: 60,height: 30,));
  static const crystal_palace =MenuItem(text: 'CRYP', icon: Image(image: AssetImage('assets/images/clubs/crystal_palace.png',),width: 60,height: 30,));
  static const fulham =MenuItem(text: 'FULH', icon: Image(image: AssetImage('assets/images/clubs/fulham.png',),width: 60,height: 30,));
  static const burnley =MenuItem(text: 'BRY', icon: Image(image: AssetImage('assets/images/clubs/burnley.png',),width: 60,height: 30,));
  static const wolves =MenuItem(text: 'WOF', icon: Image(image: AssetImage('assets/images/clubs/wolverhampton_wanderers.png',),width: 60,height: 30,));
  static const brentford =MenuItem(text: 'BRNT', icon: Image(image: AssetImage('assets/images/clubs/brentford_fc.png',),width: 60,height: 30,));
  static const everton =MenuItem(text: 'EVE', icon: Image(image: AssetImage('assets/images/clubs/everton.png',),width: 60,height: 30,));
  static const sheffield_united =MenuItem(text: 'SHF', icon: Image(image: AssetImage('assets/images/clubs/sheffield_united.png',),width: 60,height: 30,));
  static const bournemouth  =    MenuItem(text: 'BRNO', icon: Image(image: AssetImage('assets/images/clubs/bournemouth_fc.png',),width: 60,height: 30,));
  static const aston_villa  =    MenuItem(text: 'ASV', icon: Image(image: AssetImage('assets/images/clubs/aston_villa.png',),width: 60,height: 30,));
  TeamPredictionModel model=TeamPredictionModel
    (
    homeTeam: '',
    homeCode: 0,
    awayTeam: '',
    awayCode: 0,
    homeImg: '',
    awayImg: '',
    homePos: 0,
    awayPos: 0,
    homeShoots: 0,
    awayShoots: 0,
    homeCor: 0,
    awayCor: 0,
    homeShOnTarget: 0,
    awayShOnTarget: 0,
    homeCh: 0,
    awayCh: 0,
    minHomePos: 0,
    maxHomePos: 0,
    meanHomePos: 0,
    minAwayPos: 0,
    maxAwayPos: 0,
    meanAwayPos: 0,
    maxHomeShoots: 0,
    minHomeShoots: 0,
    maxAwayShoots: 0,
    meanHomeShoots: 0,
    meanAwayShoots: 0,
    maxHomeCor: 0,
    maxAwayCor: 0,
    minHomeCor: 0,
    minAwayCor: 0,
    meanHomeCor: 0,
    meanAwayCor: 0,
    maxHomeCh: 0,
    minHomeCh: 0,
    maxAwayCh: 0,
    minAwayCh: 0,
    meanHomeCh: 0,
    meanAwayCh: 0,
    maxAwayShOnTarget: 0,
    minAwayShOnTarget: 0,
    maxHomeShOnTarget: 0,
    minHomeShOnTarget: 0,
    meanHomeShOnTarget: 0,
    meanAwayShOnTarget: 0,
    minAwayShoots: 0,


  );
  void onChangedHome(BuildContext context, MenuItem item) {
    switch (item) {
      case man_city:
        model.homeTeam='مانشستر سيتي';
        model.homeImg='assets/images/clubs/manchester_city.png';
        model.homeCode=1;
        model.maxHomePos=82.1;
        model.minHomePos=36.5;
        model.maxHomeShoots=31;
        model.minHomeShoots=5;
        model.maxHomeCor=15;
        model.minHomeCor=1;
        model.maxHomeShOnTarget=15;
        model.minHomeShOnTarget=1;
        model.maxHomeCh=6;
        model.minHomeCh=0;
        model.meanHomePos=66.32;
        model.meanHomeShoots=17.18;
        model.meanHomeCor=7.42;
        model.meanHomeShOnTarget=6.28;
        model.meanHomeCh=2.5;
        emit(SelectHomeTeam());
        break;
      case liverpool:
        model.homeTeam='ليفربول';
        model.homeImg='assets/images/clubs/liverpool_fc.png';
        model.homeCode=5;
        model.maxHomePos=82.4;
        model.minHomePos=31.9;
        model.maxHomeShoots=30;
        model.minHomeShoots=4;
        model.maxHomeCor=14;
        model.minHomeCor=1;
        model.maxHomeShOnTarget=15;
        model.minHomeShOnTarget=1;
        model.maxHomeCh=6;
        model.minHomeCh=0;
        model.meanHomePos=62.92;
        model.meanHomeShoots=17.71;
        model.meanHomeCor=7.12;
        model.meanHomeShOnTarget=6.12;
        model.meanHomeCh=2.50;
        emit(SelectHomeTeam());
        break;
      case arsenal:
        model.homeTeam='ارسنال';
        model.homeImg='assets/images/clubs/arsenal_fc.png';
        model.homeCode=2;
        model.maxHomePos=81.7;
        model.minHomePos=19.6;
        model.maxHomeShoots=31;
        model.minHomeShoots=1;
        model.maxHomeCor=17;
        model.minHomeCor=0;
        model.maxHomeShOnTarget=12;
        model.minHomeShOnTarget=0;
        model.maxHomeCh=5;
        model.minHomeCh=0;
        model.meanHomePos=56.58;
        model.meanHomeShoots=15.41;
        model.meanHomeCor=6.03;
        model.meanHomeShOnTarget=5.20;
        model.meanHomeCh=1.42;
        emit(SelectHomeTeam());
        break;
      case man_united:
        model.homeTeam='مانشستر يونايتد';
        model.homeImg='assets/images/clubs/manchester_united.png';
        model.homeCode=3;
        model.maxHomePos=71.8;
        model.minHomePos=28.4;
        model.maxHomeShoots=29;
        model.minHomeShoots=2;
        model.maxHomeCor=12;
        model.minHomeCor=1;
        model.maxHomeShOnTarget=11;
        model.minHomeShOnTarget=1;
        model.maxHomeCh=6;
        model.minHomeCh=0;
        model.meanHomePos=54.49;
        model.meanHomeShoots=15.03;
        model.meanHomeCor=5.40;
        model.meanHomeShOnTarget=5.55;
        model.meanHomeCh=2.06;
        emit(SelectHomeTeam());
        break;
      case tottenham:
        model.homeTeam='توتنهام';
        model.homeImg='assets/images/clubs/tottenham_hotspur.png';
        model.homeCode=8;
        model.maxHomePos=74.2;
        model.minHomePos=28.8;
        model.maxHomeShoots=27;
        model.minHomeShoots=2;
        model.maxHomeCor=19;
        model.minHomeCor=0;
        model.maxHomeShOnTarget=13;
        model.minHomeShOnTarget=0;
        model.maxHomeCh=6;
        model.minHomeCh=0;
        model.meanHomePos=51.39;
        model.meanHomeShoots=13.22;
        model.meanHomeCor=5.16;
        model.meanHomeShOnTarget=5.27;
        model.meanHomeCh=1.96;
        emit(SelectHomeTeam());
        break;
      case chelsea:
        model.homeTeam='تشيلسي';
        model.homeImg='assets/images/clubs/chelsea_fc.png';
        model.homeCode=12;
        model.maxHomePos=80.1;
        model.minHomePos=34.3;
        model.maxHomeShoots=27;
        model.minHomeShoots=4;
        model.maxHomeCor=16;
        model.minHomeCor=0;
        model.maxHomeShOnTarget=14;
        model.minHomeShOnTarget=0;
        model.maxHomeCh=5;
        model.minHomeCh=0;
        model.meanHomePos=60.98;
        model.meanHomeShoots=14.78;
        model.meanHomeCor=6.22;
        model.meanHomeShOnTarget=5.21;
        model.meanHomeCh=1.72;
        emit(SelectHomeTeam());
        break;
      case brighton:
        model.homeTeam='برايتون';
        model.homeImg='assets/images/clubs/brighton.png';
        model.homeCode=6;
        model.maxHomePos=77.7;
        model.minHomePos=34.9;
        model.maxHomeShoots=33;
        model.minHomeShoots=2;
        model.maxHomeCor=15;
        model.minHomeCor=1;
        model.maxHomeShOnTarget=15;
        model.minHomeShOnTarget=0;
        model.maxHomeCh=5;
        model.minHomeCh=0;
        model.meanHomePos=55.80;
        model.meanHomeShoots=15.09;
        model.meanHomeCor=6.23;
        model.meanHomeShOnTarget=4.77;
        model.meanHomeCh=1.51;
        emit(SelectHomeTeam());
        break;
      case new_castle:
        model.homeTeam='نيوكاسل يونايتد';
        model.homeImg='assets/images/clubs/new_castle.png';
        model.homeCode=4;
        model.maxHomePos=77.6;
        model.minHomePos=20.8;
        model.maxHomeShoots=26;
        model.minHomeShoots=4;
        model.maxHomeCor=15;
        model.minHomeCor=0;
        model.maxHomeShOnTarget=11;
        model.minHomeShOnTarget=1;
        model.maxHomeCh=7;
        model.minHomeCh=0;
        model.meanHomePos=43.86;
        model.meanHomeShoots=13.35;
        model.meanHomeCor=5.33;
        model.meanHomeShOnTarget=4.47;
        model.meanHomeCh=1.49;
        emit(SelectHomeTeam());
        break;
      case west_ham:
        model.homeTeam='ويست هام يونايتد';
        model.homeImg='assets/images/clubs/west_ham_united.png';
        model.homeCode=14;
        model.maxHomePos=64.3;
        model.minHomePos=21.8;
        model.maxHomeShoots=25;
        model.minHomeShoots=3;
        model.maxHomeCor=14;
        model.minHomeCor=1;
        model.maxHomeShOnTarget=10;
        model.minHomeShOnTarget=1;
        model.maxHomeCh=5;
        model.minHomeCh=0;
        model.meanHomePos=44.20;
        model.meanHomeShoots=12.39;
        model.meanHomeCor=5.18;
        model.meanHomeShOnTarget=4.15;
        model.meanHomeCh=1.36;
        emit(SelectHomeTeam());
        break;
      case nottingham_forest:
        model.homeTeam='نوتنغهام فوريست';
        model.homeImg='assets/images/clubs/nottingham_forest.png';
        model.homeCode=16;
        model.maxHomePos=57.6;
        model.minHomePos=18.3;
        model.maxHomeShoots=20;
        model.minHomeShoots=3;
        model.maxHomeCor=10;
        model.minHomeCor=0;
        model.maxHomeShOnTarget=7;
        model.minHomeShOnTarget=0;
        model.maxHomeCh=4;
        model.minHomeCh=0;
        model.meanHomePos=36.84;
        model.meanHomeShoots=9.94;
        model.meanHomeCor=3;
        model.meanHomeShOnTarget=3.39;
        model.meanHomeCh=0.90;
        emit(SelectHomeTeam());
        break;
      case crystal_palace:
        model.homeTeam='كريستال بالاس';
        model.homeImg='assets/images/clubs/crystal_palace.png';
        model.homeCode=11;
        model.maxHomePos=75;
        model.minHomePos=25.7;
        model.maxHomeShoots=31;
        model.minHomeShoots=2;
        model.maxHomeCor=11;
        model.minHomeCor=0;
        model.maxHomeShOnTarget=9;
        model.minHomeShOnTarget=0;
        model.maxHomeCh=5;
        model.minHomeCh=0;
        model.meanHomePos=46.42;
        model.meanHomeShoots=10.68;
        model.meanHomeCor=4.57;
        model.meanHomeShOnTarget=3.63;
        model.meanHomeCh=1.02;
        emit(SelectHomeTeam());
        break;
      case fulham:
        model.homeTeam='فولهام';
        model.homeImg='assets/images/clubs/fulham.png';
        model.homeCode=10;
        model.maxHomePos=76.6;
        model.minHomePos=28;
        model.maxHomeShoots=24;
        model.minHomeShoots=1;
        model.maxHomeCor=13;
        model.minHomeCor=0;
        model.maxHomeShOnTarget=11;
        model.minHomeShOnTarget=0;
        model.maxHomeCh=5;
        model.minHomeCh=0;
        model.meanHomePos=50.21;
        model.meanHomeShoots=11.95;
        model.meanHomeCor=4.86;
        model.meanHomeShOnTarget=3.76;
        model.meanHomeCh=1;
        emit(SelectHomeTeam());
        break;
      case burnley:
        model.homeTeam='بيرنلي';
        model.homeImg='assets/images/clubs/burnley.png';
        model.homeCode=23;
        model.maxHomePos=56.1;
        model.minHomePos=23.3;
        model.maxHomeShoots=18;
        model.minHomeShoots=3;
        model.maxHomeCor=10;
        model.minHomeCor=1;
        model.maxHomeShOnTarget=9;
        model.minHomeShOnTarget=1;
        model.maxHomeCh=4;
        model.minHomeCh=0;
        model.meanHomePos=41.38;
        model.meanHomeShoots=10.75;
        model.meanHomeCor=4.87;
        model.meanHomeShOnTarget=3.46;
        model.meanHomeCh=1.17;
        emit(SelectHomeTeam());
        break;
      case wolves:
        model.homeTeam='ولفرهامبتون';
        model.homeImg='assets/images/clubs/wolverhampton_wanderers.png';
        model.homeCode=13;
        model.maxHomePos=72.4;
        model.minHomePos=28.6;
        model.maxHomeShoots=25;
        model.minHomeShoots=2;
        model.maxHomeCor=12;
        model.minHomeCor=0;
        model.maxHomeShOnTarget=9;
        model.minHomeShOnTarget=0;
        model.maxHomeCh=4;
        model.minHomeCh=0;
        model.meanHomePos=50.13;
        model.meanHomeShoots=11.78;
        model.meanHomeCor=5.17;
        model.meanHomeShOnTarget=3.89;
        model.meanHomeCh=0.92;
        emit(SelectHomeTeam());
        break;
      case brentford:
        model.homeTeam='برينتفورد';
        model.homeImg='assets/images/clubs/brentford_fc.png';
        model.homeCode=9;
        model.maxHomePos=72.5;
        model.minHomePos=23.7;
        model.maxHomeShoots=24;
        model.minHomeShoots=5;
        model.maxHomeCor=12;
        model.minHomeCor=0;
        model.maxHomeShOnTarget=10;
        model.minHomeShOnTarget=0;
        model.maxHomeCh=5;
        model.minHomeCh=0;
        model.meanHomePos=44.13;
        model.meanHomeShoots=11.78;
        model.meanHomeCor=4.5;
        model.meanHomeShOnTarget=4.41;
        model.meanHomeCh=1.56;
        emit(SelectHomeTeam());
        break;
      case everton:
        model.homeTeam='ايفرتون';
        model.homeImg='assets/images/clubs/everton.png';
        model.homeCode=17;
        model.maxHomePos=67.8;
        model.minHomePos=17.6;
        model.maxHomeShoots=23;
        model.minHomeShoots=1;
        model.maxHomeCor=13;
        model.minHomeCor=1;
        model.maxHomeShOnTarget=10;
        model.minHomeShOnTarget=0;
        model.maxHomeCh=4;
        model.minHomeCh=0;
        model.meanHomePos=43.5;
        model.meanHomeShoots=11.48;
        model.meanHomeCor=4.77;
        model.meanHomeShOnTarget=4.03;
        model.meanHomeCh=1.19;
        emit(SelectHomeTeam());
        break;

      case bournemouth:
        model.homeTeam='بورنموث';
        model.homeImg='assets/images/clubs/bournemouth_fc.png';
        model.homeCode=15;
        model.maxHomePos=64.6;
        model.minHomePos=19.9;
        model.maxHomeShoots=19;
        model.minHomeShoots=3;
        model.maxHomeCor=8;
        model.minHomeCor=0;
        model.maxHomeShOnTarget=9;
        model.minHomeShOnTarget=0;
        model.maxHomeCh=2;
        model.minHomeCh=0;
        model.meanHomePos=40.51;
        model.meanHomeShoots=9.92;
        model.meanHomeCor=4.05;
        model.meanHomeShOnTarget=3.64;
        model.meanHomeCh=1.01;
        emit(SelectHomeTeam());
        break;
      case aston_villa:
        model.homeTeam='استون فيلا';
        model.homeImg='assets/images/clubs/aston_villa.png';
        model.homeCode=7;
        model.maxHomePos=64.6;
        model.minHomePos=19.9;
        model.maxHomeShoots=19;
        model.minHomeShoots=3;
        model.maxHomeCor=8;
        model.minHomeCor=0;
        model.maxHomeShOnTarget=9;
        model.minHomeShOnTarget=0;
        model.maxHomeCh=2;
        model.minHomeCh=0;
        model.meanHomePos=47.96;
        model.meanHomeShoots=12.75;
        model.meanHomeCor=5.16;
        model.meanHomeShOnTarget=4.59;
        model.meanHomeCh=1.45;
        emit(SelectHomeTeam());
        break;
    }
  }

  void onChangedAway(BuildContext context, MenuItem item) {
    switch (item) {
      case man_city:
        model.awayTeam='مانشستر سيتي';
        model.awayImg='assets/images/clubs/manchester_city.png';
        model.awayCode=1;
        model.maxAwayPos=80.9;
        model.minAwayPos=36.5;
        model.maxAwayShoots=31;
        model.minAwayShoots=5;
        model.maxAwayCor=14;
        model.minAwayCor=1;
        model.maxAwayShOnTarget=15;
        model.minAwayShOnTarget=1;
        model.maxAwayCh=6;
        model.minAwayCh=0;
        model.meanAwayPos=65.67;
        model.meanAwayShoots=16.77;
        model.meanAwayCor=7.02;
        model.meanAwayShOnTarget=6.07;
        model.meanAwayCh=2.36;
        emit(SelectAwayTeam());
        break;
      case liverpool:
        model.awayTeam='ليفربول';
        model.awayImg='assets/images/clubs/liverpool_fc.png';
        model.awayCode=5;
        model.maxAwayPos=82.4;
        model.minAwayPos=31.9;
        model.maxAwayShoots=30;
        model.minAwayShoots=4;
        model.maxAwayCor=14;
        model.minAwayCor=1;
        model.maxAwayShOnTarget=15;
        model.minAwayShOnTarget=1;
        model.maxAwayCh=6;
        model.minAwayCh=0;
        model.meanAwayPos=62.18;
        model.meanAwayShoots=17.03;
        model.meanAwayCor=6.85;
        model.meanAwayShOnTarget=5.98;
        model.meanAwayCh=2.49;
        emit(SelectAwayTeam());
        break;
      case arsenal:
        model.awayTeam='ارسنال';
        model.awayImg='assets/images/clubs/arsenal_fc.png';
        model.awayCode=2;
        model.maxAwayPos=81.7;
        model.minAwayPos=19.6;
        model.maxAwayShoots=31;
        model.minAwayShoots=1;
        model.maxAwayCor=17;
        model.minAwayCor=0;
        model.maxAwayShOnTarget=12;
        model.minAwayShOnTarget=0;
        model.maxAwayCh=5;
        model.minAwayCh=0;
        model.meanAwayPos=55.46;
        model.meanAwayShoots=14.36;
        model.meanAwayCor=5.57;
        model.meanAwayShOnTarget=4.85;
        model.meanAwayCh=1.37;
        emit(SelectAwayTeam());
        break;
      case man_united:
        model.awayTeam='مانشستر يونايتد';
        model.awayImg='assets/images/clubs/manchester_united.png';
        model.awayCode=3;
        model.maxAwayPos=71.8;
        model.minAwayPos=28.4;
        model.maxAwayShoots=29;
        model.minAwayShoots=2;
        model.maxAwayCor=12;
        model.minAwayCor=1;
        model.maxAwayShOnTarget=11;
        model.minAwayShOnTarget=1;
        model.maxAwayCh=6;
        model.minAwayCh=0;
        model.meanAwayPos=54.12;
        model.meanAwayShoots=14.26;
        model.meanAwayCor=5.17;
        model.meanAwayShOnTarget=5.38;
        model.meanAwayCh=1.90;
        emit(SelectAwayTeam());
        break;
      case tottenham:
        model.awayTeam='توتنهام';
        model.awayImg='assets/images/clubs/tottenham_hotspur.png';
        model.awayCode=8;
        model.maxAwayPos=74.2;
        model.minAwayPos=28.8;
        model.maxAwayShoots=27;
        model.minAwayShoots=2;
        model.maxAwayCor=19;
        model.minAwayCor=0;
        model.maxAwayShOnTarget=13;
        model.minAwayShOnTarget=0;
        model.maxAwayCh=6;
        model.minAwayCh=0;
        model.meanAwayPos=51.14;
        model.meanAwayShoots=12.73;
        model.meanAwayCor=4.91;
        model.meanAwayShOnTarget=5.02;
        model.meanAwayCh=1.83;
        emit(SelectAwayTeam());
        break;
      case chelsea:
        model.awayTeam='تشيلسي';
        model.awayImg='assets/images/clubs/chelsea_fc.png';
        model.awayCode=12;
        model.maxAwayPos=80.1;
        model.minAwayPos=34.3;
        model.maxAwayShoots=27;
        model.minAwayShoots=4;
        model.maxAwayCor=16;
        model.minAwayCor=0;
        model.maxAwayShOnTarget=14;
        model.minAwayShOnTarget=0;
        model.maxAwayCh=5;
        model.minAwayCh=0;
        model.meanAwayPos=60.89;
        model.meanAwayShoots=14.33;
        model.meanAwayCor=5.94;
        model.meanAwayShOnTarget=5.07;
        model.meanAwayCh=1.69;
        emit(SelectAwayTeam());
        break;
      case brighton:
        model.awayTeam='برايتون';
        model.awayImg='assets/images/clubs/brighton.png';
        model.awayCode=6;
        model.maxAwayPos=77.7;
        model.minAwayPos=34.9;
        model.maxAwayShoots=33;
        model.minAwayShoots=2;
        model.maxAwayCor=15;
        model.minAwayCor=1;
        model.maxAwayShOnTarget=15;
        model.minAwayShOnTarget=0;
        model.maxAwayCh=5;
        model.minAwayCh=0;
        model.meanAwayPos=55.37;
        model.meanAwayShoots=13.93;
        model.meanAwayCor=5.71;
        model.meanAwayShOnTarget=4.62;
        model.meanAwayCh=1.52;
        emit(SelectAwayTeam());
        break;
      case new_castle:
        model.awayTeam='نيوكاسل يونايتد';
        model.awayImg='assets/images/clubs/new_castle.png';
        model.awayCode=4;
        model.maxAwayPos=77.6;
        model.minAwayPos=20.8;
        model.maxAwayShoots=26;
        model.minAwayShoots=4;
        model.maxAwayCor=15;
        model.minAwayCor=0;
        model.maxAwayShOnTarget=11;
        model.minAwayShOnTarget=1;
        model.maxAwayCh=7;
        model.minAwayCh=0;
        model.meanAwayPos=43.58;
        model.meanAwayShoots=12.42;
        model.meanAwayCor=5.18;
        model.meanAwayShOnTarget=4.28;
        model.meanAwayCh=1.35;
        emit(SelectAwayTeam());
        break;
      case west_ham:
        model.awayTeam='ويست هام يونايتد';
        model.awayImg='assets/images/clubs/west_ham_united.png';
        model.awayCode=14;
        model.maxAwayPos=64.3;
        model.minAwayPos=21.8;
        model.maxAwayShoots=25;
        model.minAwayShoots=3;
        model.maxAwayCor=14;
        model.minAwayCor=1;
        model.maxAwayShOnTarget=10;
        model.minAwayShOnTarget=1;
        model.maxAwayCh=5;
        model.minAwayCh=0;
        model.meanAwayPos=44.32;
        model.meanAwayShoots=12.14;
        model.meanAwayCor=5.12;
        model.meanAwayShOnTarget=4.05;
        model.meanAwayCh=1.33;
        emit(SelectAwayTeam());
        break;
      case nottingham_forest:
        model.awayTeam='نوتنغهام فوريست';
        model.awayImg='assets/images/clubs/nottingham_forest.png';
        model.awayCode=16;
        model.maxAwayPos=57.6;
        model.minAwayPos=18.3;
        model.maxAwayShoots=20;
        model.minAwayShoots=3;
        model.maxAwayCor=10;
        model.minAwayCor=0;
        model.maxAwayShOnTarget=7;
        model.minAwayShOnTarget=0;
        model.maxAwayCh=4;
        model.minAwayCh=0;
        model.meanAwayPos=37.22;
        model.meanAwayShoots=9.68;
        model.meanAwayCor=3.36;
        model.meanAwayShOnTarget=3.10;
        model.meanAwayCh=0.86;
        emit(SelectAwayTeam());
        break;
      case crystal_palace:
        model.awayTeam='كريستال بالاس';
        model.awayImg='assets/images/clubs/crystal_palace.png';
        model.awayCode=11;
        model.maxAwayPos=75;
        model.minAwayPos=25.7;
        model.maxAwayShoots=31;
        model.minAwayShoots=2;
        model.maxAwayCor=11;
        model.minAwayCor=0;
        model.maxAwayShOnTarget=9;
        model.minAwayShOnTarget=0;
        model.maxAwayCh=5;
        model.minAwayCh=0;
        model.meanAwayPos=45.84;
        model.meanAwayShoots=10.41;
        model.meanAwayCor=4.5;
        model.meanAwayShOnTarget=3.64;
        model.meanAwayCh=0.99;
        emit(SelectAwayTeam());
        break;
      case fulham:
        model.awayTeam='فولهام';
        model.awayImg='assets/images/clubs/fulham.png';
        model.awayCode=10;
        model.maxAwayPos=76.6;
        model.minAwayPos=28;
        model.maxAwayShoots=24;
        model.minAwayShoots=1;
        model.maxAwayCor=13;
        model.minAwayCor=0;
        model.maxAwayShOnTarget=11;
        model.minAwayShOnTarget=0;
        model.maxAwayCh=5;
        model.minAwayCh=0;
        model.meanAwayPos=49.19;
        model.meanAwayShoots=11.46;
        model.meanAwayCor=4.59;
        model.meanAwayShOnTarget=3.75;
        model.meanAwayCh=1.0;
        emit(SelectAwayTeam());
        break;
      case burnley:
        model.awayTeam='بيرنلي';
        model.awayImg='assets/images/clubs/burnley.png';
        model.awayCode=23;
        model.maxAwayPos=56.1;
        model.minAwayPos=23.3;
        model.maxAwayShoots=18;
        model.minAwayShoots=3;
        model.maxAwayCor=10;
        model.minAwayCor=1;
        model.maxAwayShOnTarget=9;
        model.minAwayShOnTarget=1;
        model.maxAwayCh=4;
        model.minAwayCh=0;
        model.meanAwayPos=40.74;
        model.meanAwayShoots=10.30;
        model.meanAwayCor=4.64;
        model.meanAwayShOnTarget=3.34;
        model.meanAwayCh=1.10;
        emit(SelectAwayTeam());
        break;
      case wolves:
        model.awayTeam='ولفرهامبتون';
        model.awayImg='assets/images/clubs/wolverhampton_wanderers.png';
        model.awayCode=13;
        model.maxAwayPos=72.4;
        model.minAwayPos=28.6;
        model.maxAwayShoots=25;
        model.minAwayShoots=2;
        model.maxAwayCor=12;
        model.minAwayCor=0;
        model.maxAwayShOnTarget=9;
        model.minAwayShOnTarget=0;
        model.maxAwayCh=4;
        model.minAwayCh=0;
        model.meanAwayPos=49.65;
        model.meanAwayShoots=11.20;
        model.meanAwayCor=4.93;
        model.meanAwayShOnTarget=3.64;
        model.meanAwayCh=0.85;
        emit(SelectAwayTeam());
        break;
      case brentford:
        model.awayTeam='برينتفورد';
        model.awayImg='assets/images/clubs/brentford_fc.png';
        model.awayCode=9;
        model.maxAwayPos=72.5;
        model.minAwayPos=23.7;
        model.maxAwayShoots=24;
        model.minAwayShoots=5;
        model.maxAwayCor=12;
        model.minAwayCor=0;
        model.maxAwayShOnTarget=10;
        model.minAwayShOnTarget=0;
        model.maxAwayCh=5;
        model.minAwayCh=0;
        model.meanAwayPos=44.01;
        model.meanAwayShoots=11.18;
        model.meanAwayCor=4.23;
        model.meanAwayShOnTarget=4.17;
        model.meanAwayCh=1.52;
        emit(SelectAwayTeam());
        break;
      case everton:
        model.awayTeam='ايفرتون';
        model.awayImg='assets/images/clubs/everton.png';
        model.awayCode=17;
        model.maxAwayPos=67.8;
        model.minAwayPos=17.6;
        model.maxAwayShoots=23;
        model.minAwayShoots=1;
        model.maxAwayCor=13;
        model.minAwayCor=1;
        model.maxAwayShOnTarget=10;
        model.minAwayShOnTarget=0;
        model.maxAwayCh=4;
        model.minAwayCh=0;
        model.meanAwayPos=42.90;
        model.meanAwayShoots=11.10;
        model.meanAwayCor=4.42;
        model.meanAwayShOnTarget=3.84;
        model.meanAwayCh=1.14;
        emit(SelectAwayTeam());
        break;
      case bournemouth:
        model.awayTeam='بورنموث';
        model.awayImg='assets/images/clubs/bournemouth_fc.png';
        model.awayCode=15;
        model.maxAwayPos=64.6;
        model.minAwayPos=19.9;
        model.maxAwayShoots=19;
        model.minAwayShoots=3;
        model.maxAwayCor=8;
        model.minAwayCor=0;
        model.maxAwayShOnTarget=9;
        model.minAwayShOnTarget=0;
        model.maxAwayCh=2;
        model.minAwayCh=0;
        model.meanAwayPos=40.1;
        model.meanAwayShoots=9;
        model.meanAwayCor=3;
        model.meanAwayShOnTarget=3;
        model.meanAwayCh=0;
        emit(SelectAwayTeam());
        break;
      case aston_villa:
        model.awayTeam='استون فيلا';
        model.awayImg='assets/images/clubs/aston_villa.png';
        model.awayCode=7;
        model.maxAwayPos=64.6;
        model.minAwayPos=19.9;
        model.maxAwayShoots=19;
        model.minAwayShoots=3;
        model.maxAwayCor=8;
        model.minAwayCor=0;
        model.maxAwayShOnTarget=9;
        model.minAwayShOnTarget=0;
        model.maxAwayCh=2;
        model.minAwayCh=0;
        model.meanAwayPos=47.8;
        model.meanAwayShoots=12;
        model.meanAwayCor=5;
        model.meanAwayShOnTarget=4;
        model.meanAwayCh=1;
        emit(SelectHomeTeam());
        break;
    }
  }
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case OffLineFailure:
        return OFF_LINE_FAILURE_MESSAGE;
      default:
        return "Unexpected error, please try again later";
    }
  }
}


