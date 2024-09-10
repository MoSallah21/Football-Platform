

import '../team.dart';

class LiveMatchData {
  // bool boolEvent = false;
  // bool boolLineUp = false;
  // bool boolStats = false;

  List<Event> allEvent = [];
  late LineUps lineUps;
  late TeamStatistics fixStats;
  getAllEvent(List<dynamic> events) {
    allEvent = events.map((dynamic e) => Event.fromJson(e)).toList();
    //  boolEvent = true;
  }

  getLineUp(List<dynamic> lineup) {
    lineUps = LineUps.fromJson(lineup);
    //  boolLineUp = true;
  }

  getStats(List<dynamic> homeStats, List<dynamic> awayStats) {
    fixStats = TeamStatistics(homeStats, awayStats);
    //  boolStats = true;
  }
}

class Event {
  final String type;
  final String detail;
  final Team team;
  final Time time;
  final EventPlayer player;
  final EventAssist assist;

  Event(this.type, this.detail, this.team, this.time, this.player, this.assist);

  factory Event.fromJson(Map<String, dynamic> e) {
    return Event(
        e['type']??'Null',
        e['detail']??'Null',
        Team.fromJson(e['team']),
        Time.fromJson(e['time']),
        EventPlayer.fromJson(e['player']),
        EventAssist.fromJson(e['assist']));
  }
}

class Time {
  final int time;
  Time(this.time);
  factory Time.fromJson(Map<String, dynamic> e) {
    return Time(e['elapsed'] ?? 0);
  }
}

class EventPlayer {
  final String name;
  EventPlayer(this.name);
  factory EventPlayer.fromJson(Map<String, dynamic> e) {
    return EventPlayer(e['name'] ?? "");
  }
}

class EventAssist {
  final String name;
  EventAssist(this.name);
  factory EventAssist.fromJson(Map<String, dynamic> e) {
    return EventAssist(e['name'] ?? "");
  }
}

class LineUps {
  final TeamLineUp home;
  final TeamLineUp away;
  LineUps(this.home, this.away);

  factory LineUps.fromJson(List<dynamic> list) {
    return LineUps(TeamLineUp.fromJson(list[0]), TeamLineUp.fromJson(list[1]));
  }
}

class TeamLineUp {
  final Coach coach;
  final String formation;
  final StartAndSub startAndSub;

  TeamLineUp(this.coach, this.formation, this.startAndSub);

  factory TeamLineUp.fromJson(Map<String, dynamic> e) {
    return TeamLineUp(Coach.formJson(e['coach']), e['formation'],
        StartAndSub(e['startXI'], e['substitutes']));
  }
}

class Coach {
  final String name;
  final String photo;

  Coach(this.name, this.photo);

  factory Coach.formJson(Map<String, dynamic> e) {
    return Coach(e['name']??"No Name Yet", e['photo']??"https://media-2.api-sports.io/football/coachs/3946.png");
  }
}

class StartAndSub {
  List<LineUpPlayer> starteleven = [];
  List<LineUpPlayer> substitue = [];

  StartAndSub(List<dynamic> start, List<dynamic> sub) {
    starteleven =
        start.map((dynamic e) => LineUpPlayer.fromJson(e['player'])).toList();
    substitue =
        sub.map((dynamic e) => LineUpPlayer.fromJson(e['player'])).toList();
  }
}

class LineUpPlayer {
  final String name;
  final int number;
  final String pos;
  final String grid;

  LineUpPlayer(this.name, this.number, this.pos, this.grid);
  factory LineUpPlayer.fromJson(Map<String, dynamic> e) {
    return LineUpPlayer(
        e['name'], e['number'], e['pos'] ?? "-", e['grid'] ?? "");
  }
}

class TeamStatistics {
  List<Stats> home = [];
  List<Stats> away = [];

  TeamStatistics(List<dynamic> homeStats, List<dynamic> awayStats) {
    home = homeStats.map((dynamic e) => Stats.fromJson(e)).toList();
    away = awayStats.map((dynamic e) => Stats.fromJson(e)).toList();
  }
}

class Stats {
  final String label;
  final String value;

  Stats(this.label, this.value);

  factory Stats.fromJson(Map<String, dynamic> e) {
    return Stats(e['type'], e['value'] == null ? '0' : e['value'].toString());
  }
}
