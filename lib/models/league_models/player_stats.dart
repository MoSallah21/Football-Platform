import 'package:football_platform/models/league_models/team.dart';

class PlayerStats {
  final Player player;
  final Stats stats;
  PlayerStats(this.player, this.stats);

  factory PlayerStats.fromJson(Map<String, dynamic> e) {
    return PlayerStats(
        Player.fromJson(e['player']), Stats.fromJson(e['statistics'][0]));
  }
}

class Player {
  final int id;
  final String name;
  final String image;

  Player(this.id, this.name, this.image);

  factory Player.fromJson(Map<String, dynamic> e) {
    return Player(e['id'], e['name'], e['photo']);
  }
}

class Stats {
  final GoalStats goals;
  final Cards card;
  final Team team;

  Stats(this.goals, this.card, this.team);

  factory Stats.fromJson(Map<String, dynamic> e) {
    return Stats(GoalStats.formJson(e['goals']), Cards.formJson(e['cards']),
        Team.fromJson(e['team']));
  }
}


class GoalStats {
  final int total;
  final int assists;

  GoalStats(this.total, this.assists);
  factory GoalStats.formJson(Map<String, dynamic> e) {
    return GoalStats(e['total']??0, e['assists']??0);
  }
}

class Cards {
  final int yellow;
  final int red;
  Cards(this.yellow, this.red);
  factory Cards.formJson(Map<String, dynamic> e) {
    return Cards(e['yellow'], e['red']);
  }
}
