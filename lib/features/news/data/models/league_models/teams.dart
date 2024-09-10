import 'team.dart';

class Teams {
  final Team home;
  final Team away;

  Teams(this.home, this.away);

  factory Teams.fromJson(Map<String, dynamic> e) {
    return Teams(Team.fromJson(e['home']), Team.fromJson(e['away']));
  }
}
