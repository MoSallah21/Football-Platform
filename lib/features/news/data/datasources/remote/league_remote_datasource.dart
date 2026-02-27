import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../core/strings/constantse.dart';
import '../../models/league_models/fixture_data.dart';
import '../../models/league_models/liveFixtures/live_fixture_data.dart';
import '../../models/league_models/player_stats.dart';
import '../../models/league_models/table.dart';

abstract class LeagueRemoteDatasource{
  Future<List<TableData>> getLeagueTable(String league);
  Future<List<PlayerStats>> topScorers(String league);
  Future<List<PlayerStats>> topAssists(String league);
  Future<List<PlayerStats>> yellowCard(String league);
  Future<List<PlayerStats>> redCard(String league);
  Future<List<FixtureData>> getAllMatches(String league);
  Future<LiveMatchData> getLiveMatchData(int id);
  Future<List<FixtureData>> getLiveMatches(String league);
  Future<List<FixtureData>> getUpComingMatches(String league);
}

class LeagueRemoteDatasourceImp extends LeagueRemoteDatasource{
  @override
  Future<List<FixtureData>> getAllMatches(String league)async {
    String url = "https://v3.football.api-sports.io/fixtures/?league=$league&season=2025";
    List<FixtureData> table = [];
    http.Response res = await http.get(Uri.parse(url), headers: headers);

    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      List<dynamic> temp = data['response'];
      table = temp.map((dynamic e) => FixtureData.formJson(e)).toList();

      return table;
    }
    return table;
  }

  @override
  Future<List<TableData>> getLeagueTable(String league)async {
    String url =
        "https://v3.football.api-sports.io/standings?league=$league&season=2025";
    List<TableData> table;
    http.Response res = await http.get(Uri.parse(url), headers: headers);
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      List<dynamic> temp = data['response'][0]['league']['standings'][0];
      table = temp.map((dynamic e) => TableData.formJson(e)).toList();
      return table;
    } else
      table = [];
    return table;
  }

  @override
  Future<LiveMatchData> getLiveMatchData(int id)async {
    String url = "https://v3.football.api-sports.io/fixtures?id=$id";
    http.Response res = await http.get(Uri.parse(url), headers: headers);
    LiveMatchData lmd = LiveMatchData();
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);

      lmd.getAllEvent(data['response'][0]['events']);
      lmd.getLineUp(data['response'][0]['lineups']);
      lmd.getStats(data['response'][0]['statistics'][0]['statistics'],
          (data['response'][0]['statistics'][1]['statistics']));
    }
    return lmd;
  }

  @override
  Future<List<FixtureData>> getLiveMatches(String league)async {
    String url =
        "https://v3.football.api-sports.io/fixtures/?league=$league&season=2025&live=all";

    List<FixtureData> table;
    http.Response res = await http.get(Uri.parse(url), headers: headers);

    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      List<dynamic> temp = data['response'];
      table = temp.map((dynamic e) => FixtureData.formJson(e)).toList();
      return table;
    } else
      table = [];

    return table;
  }

  @override
  Future<List<FixtureData>> getUpComingMatches(String league)async {
    String url =
        "https://v3.football.api-sports.io/fixtures/?league=$league&season=2025";

    List<FixtureData> table;
    http.Response res = await http.get(Uri.parse(url), headers: headers);

    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      List<dynamic> temp = data['response'];
      table = temp.map((dynamic e) => FixtureData.formJson(e)).toList();
      return table;
    } else
      table = [];

    return table;
  }

  @override
  Future<List<PlayerStats>> redCard(String league)async {
    String url =
        "https://v3.football.api-sports.io/players/topredcards?league=$league&season=2025";

    List<PlayerStats> table;
    http.Response res = await http.get(Uri.parse(url), headers: headers);

    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      List<dynamic> temp = data['response'];

      table = temp.map((dynamic e) => PlayerStats.fromJson(e)).toList();

      return table;
    } else
      table = [];

    return table;
  }

  @override
  Future<List<PlayerStats>> topAssists(String league)async {
    String url =
        "https://v3.football.api-sports.io/players/topassists?league=$league&season=2025";

    List<PlayerStats> table;
    http.Response res = await http.get(Uri.parse(url), headers: headers);

    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      List<dynamic> temp = data['response'];

      table = temp.map((dynamic e) => PlayerStats.fromJson(e)).toList();

      return table;
    } else
      table = [];

    return table;
  }

  @override
  Future<List<PlayerStats>> topScorers(String league)async {
    String url =
        "https://v3.football.api-sports.io/players/topscorers?league=$league&season=2025";
    List<PlayerStats> table;
    http.Response res = await http.get(Uri.parse(url), headers: headers);
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      List<dynamic> temp = data['response'];
      table = temp.map((dynamic e) => PlayerStats.fromJson(e)).toList();
      return table;
    } else
      table = [];

    return table;
  }

  @override
  Future<List<PlayerStats>> yellowCard(String league)async {
    String url =
        "https://v3.football.api-sports.io/players/topyellowcards?league=$league&season=2025";

    List<PlayerStats> table;
    http.Response res = await http.get(Uri.parse(url), headers: headers);

    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      List<dynamic> temp = data['response'];

      table = temp.map((dynamic e) => PlayerStats.fromJson(e)).toList();

      return table;
    } else
      table = [];
    return table;
  }

}