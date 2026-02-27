
class TeamPredictionModel {
  String homeTeam;
  double homeCode;
  String awayTeam;
  double awayCode;
  String homeImg;
  String awayImg;
  double homePos;
  double awayPos;
  double homeShoots;
  double awayShoots;
  double homeCor;
  double awayCor;
  double homeShOnTarget;
  double awayShOnTarget;
  double homeCh;
  double awayCh;
  double minHomePos;
  double meanHomePos;
  double minAwayPos;
  double meanAwayPos;
  double minHomeShoots;
  double meanHomeShoots;
  double meanAwayShoots;
  double minAwayShoots;
  double minHomeCor;
  double meanHomeCor;
  double meanAwayCor;
  double minAwayCor;
  double minHomeShOnTarget;
  double minAwayShOnTarget;
  double meanHomeShOnTarget;
  double meanAwayShOnTarget;
  double minHomeCh;
  double minAwayCh;
  double meanHomeCh;
  double meanAwayCh;
  double maxHomePos;
  double maxAwayPos;

  double maxHomeShoots;
  double maxAwayShoots;
  double maxHomeCor;
  double maxAwayCor;
  double maxHomeShOnTarget;
  double maxAwayShOnTarget;
  double maxHomeCh;
  double maxAwayCh;




  TeamPredictionModel({
    required  this.homeTeam,
    required  this.homeCode,
    required  this.awayTeam,
    required  this.awayCode,
    required  this.homeImg,
    required  this.awayImg,
    required  this.homePos,
    required  this.meanHomePos,
    required  this.awayPos,
    required  this.meanAwayPos,
    required  this.homeShoots,
    required  this.awayShoots,
    required  this.homeCor,
    required  this.awayCor,
    required  this.homeShOnTarget,
    required  this.awayShOnTarget,
    required  this.homeCh,
    required  this.awayCh,
    required  this.meanHomeCh,
    required  this.meanAwayCh,
    required  this.minHomePos,
    required  this.maxHomePos,
    required  this.minAwayPos,
    required  this.maxAwayPos,
    required  this.maxHomeShoots,
    required  this.minHomeShoots,
    required  this.maxAwayShoots,
    required  this.maxHomeCor,
    required  this.maxAwayCor,
    required  this.minHomeCor,
    required  this.minAwayCor,
    required  this.maxHomeCh,
    required  this.minHomeCh,
    required  this.maxAwayCh,
    required  this.minAwayCh,
    required  this.maxAwayShOnTarget,
    required  this.minAwayShOnTarget,
    required  this.maxHomeShOnTarget,
    required  this.minHomeShOnTarget,
    required  this.minAwayShoots,
    required  this.meanHomeShoots,
    required  this.meanAwayShoots,
    required  this.meanHomeCor,
    required  this.meanAwayCor,
    required  this.meanHomeShOnTarget,
    required  this.meanAwayShOnTarget,








  });

  TeamPredictionModel copyWith({
    String? homeTeam,
    double? homeCode,
    String? awayTeam,
    double? awayCode,
    String? homeImg,
    String? awayImg,
    double? homePos,
    double? awayPos,
    double? homeShoots,
    double? awayShoots,
    double? homeCor,
    double? awayCor,
    double? homeShOnTarget,
    double? awayShOnTarget,
    double? homeCh,
    double? awayCh,
    double? minHomePos,
    double? meanHomePos,
    double? maxHomePos,
    double? minAwayPos,
    double? meanAwayPos,
    double? maxAwayPos,
    double? minHomeShoots,
    double? meanHomeShoots,
    double? maxHomeShoots,
    double? minAwayShoots,
    double? meanAwayShoots,
    double? maxAwayShoots,
    double? minHomeCor,
    double? meanHomeCor,
    double? maxHomeCor,
    double? minAwayCor,
    double? meanAwayCor,
    double? maxAwayCor,
    double? minHomeShOnTarget,
    double? meanHomeShOnTarget,
    double? maxHomeShOnTarget,
    double? minAwayShOnTarget,
    double? meanAwayShOnTarget,
    double? maxAwayShOnTarget,
    double? minHomeCh,
    double? meanHomeCh,
    double? maxHomeCh,
    double? minAwayCh,
    double? meanAwayCh,
    double? maxAwayCh,
  }) {
    return TeamPredictionModel(
      homeTeam: homeTeam ?? this.homeTeam,
      homeCode: homeCode ?? this.homeCode,
      awayTeam: awayTeam ?? this.awayTeam,
      awayCode: awayCode ?? this.awayCode,
      homeImg: homeImg ?? this.homeImg,
      awayImg: awayImg ?? this.awayImg,
      homePos: homePos ?? this.homePos,
      meanHomePos: meanHomePos ?? this.meanHomePos,
      awayPos: awayPos ?? this.awayPos,
      meanAwayPos: meanAwayPos ?? this.meanAwayPos,
      homeShoots: homeShoots ?? this.homeShoots,
      awayShoots: awayShoots ?? this.awayShoots,
      homeCor: homeCor ?? this.homeCor,
      awayCor: awayCor ?? this.awayCor,
      homeShOnTarget: homeShOnTarget ?? this.homeShOnTarget,
      awayShOnTarget: awayShOnTarget ?? this.awayShOnTarget,
      homeCh: homeCh ?? this.homeCh,
      awayCh: awayCh ?? this.awayCh,
      meanHomeCh: meanHomeCh ?? this.meanHomeCh,
      meanAwayCh: meanAwayCh ?? this.meanAwayCh,
      minHomePos: minHomePos ?? this.minHomePos,
      maxHomePos: maxHomePos ?? this.maxHomePos,
      minAwayPos: minAwayPos ?? this.minAwayPos,
      maxAwayPos: maxAwayPos ?? this.maxAwayPos,
      minHomeShoots: minHomeShoots ?? this.minHomeShoots,
      meanHomeShoots: meanHomeShoots ?? this.meanHomeShoots,
      maxHomeShoots: maxHomeShoots ?? this.maxHomeShoots,
      minAwayShoots: minAwayShoots ?? this.minAwayShoots,
      meanAwayShoots: meanAwayShoots ?? this.meanAwayShoots,
      maxAwayShoots: maxAwayShoots ?? this.maxAwayShoots,
      minHomeCor: minHomeCor ?? this.minHomeCor,
      meanHomeCor: meanHomeCor ?? this.meanHomeCor,
      maxHomeCor: maxHomeCor ?? this.maxHomeCor,
      minAwayCor: minAwayCor ?? this.minAwayCor,
      meanAwayCor: meanAwayCor ?? this.meanAwayCor,
      maxAwayCor: maxAwayCor ?? this.maxAwayCor,
      minHomeShOnTarget: minHomeShOnTarget ?? this.minHomeShOnTarget,
      meanHomeShOnTarget:
      meanHomeShOnTarget ?? this.meanHomeShOnTarget,
      maxHomeShOnTarget:
      maxHomeShOnTarget ?? this.maxHomeShOnTarget,
      minAwayShOnTarget:
      minAwayShOnTarget ?? this.minAwayShOnTarget,
      meanAwayShOnTarget:
      meanAwayShOnTarget ?? this.meanAwayShOnTarget,
      maxAwayShOnTarget:
      maxAwayShOnTarget ?? this.maxAwayShOnTarget,
      minHomeCh: minHomeCh ?? this.minHomeCh,
      maxHomeCh: maxHomeCh ?? this.maxHomeCh,
      minAwayCh: minAwayCh ?? this.minAwayCh,
      maxAwayCh: maxAwayCh ?? this.maxAwayCh,
    );
  }
  
}
