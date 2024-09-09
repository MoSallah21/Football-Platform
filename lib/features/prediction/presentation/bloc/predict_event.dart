part of 'predict_bloc.dart';

abstract class PredictEvent extends Equatable{
  @override
  List<Object?> get props => [];
}
class PredictResultEvent extends PredictEvent{
  late double  mode;
  late double  homeCode;
  late double  awayCode;
  double? homePoss;
  double? homeShoots;
  double? homeShootsOn;
  double? homeCorners;
  double? homeChances;
  double? awayPoss;
  double? awayShoots;
  double? awayShootsOn;
  double? awayCorners;
  double? awayChances;
  List<Object?> get props => [
    mode,
    homeCode,
    homePoss,
    homeShoots,
    homeShootsOn,
    homeCorners,
    homeChances,
    awayCode,
    awayPoss,
    awayShoots,
    awayShootsOn,
    awayCorners,
    awayChances

  ];

  PredictResultEvent(
      {
        required this.mode,
        required this.homeCode,
        required this.awayCode,
        required this.homePoss,
        required this.homeShoots,
        required this.homeShootsOn,
        required this.homeCorners,
        required this.homeChances,
        required  this.awayPoss,
        required this.awayShoots,
        required  this.awayShootsOn,
        required this.awayCorners,
        required this.awayChances});
}

