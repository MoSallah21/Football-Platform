import 'team.dart';

class TableData {
  int rank;
  Team team;
  int points;
  int goalsDiff;
  String form;
  All all;

  TableData(
      this.rank, this.team, this.points, this.goalsDiff, this.form, this.all);

  factory TableData.formJson(Map<String, dynamic> json) {
    return TableData(json['rank'], Team.fromJson(json['team']), json['points'],
        json['goalsDiff'], json['form']==null?'':json['form'],
        All.fromJson(json['all']));
  }
}

class All {
  int played;
  int win;
  int draw;
  int lose;

  All(this.played, this.win, this.draw, this.lose);

  factory All.fromJson(Map<String, dynamic> json) {
    return All(json['played'], json['win'], json['draw'], json['lose']);
  }
}
