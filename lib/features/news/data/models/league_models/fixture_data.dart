import 'fixture.dart';
import 'goals.dart';
import 'leagues.dart';
import 'teams.dart';
class FixtureData {
  final Fixture fixture;
  final League league;
  final Teams teams;
  final Goals goals;

  FixtureData(this.fixture, this.league, this.teams, this.goals);
  factory FixtureData.formJson(Map<String, dynamic> e) {
    return FixtureData(Fixture.fromJson(e["fixture"]), League.fromJson(e['league']), Teams.fromJson(e['teams']),Goals.formJson(e['goals']));
  }
}
