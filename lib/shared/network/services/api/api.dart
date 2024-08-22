import 'dart:convert';
import 'package:football_platform/models/league_models/fixture_data.dart';
import 'package:football_platform/models/league_models/liveFixtures/live_fixture_data.dart';
import 'package:football_platform/models/league_models/player_stats.dart';
import 'package:football_platform/models/league_models/table.dart';
import 'package:http/http.dart' as http;

class Api {
  static final headers = {
    'x-rapidapi-host': "v3.football.api-sports.io",
    'x-rapidapi-key': "eb46070093fa26915792ffc3ee302dd4",
  };

  static Future<List<TableData>> getLeagueTable(String league) async {
    String url =
        "https://v3.football.api-sports.io/standings?league=$league&season=2023";
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

  static Future<List<PlayerStats>> topScorers(String league) async {
    String url =
        "https://v3.football.api-sports.io/players/topscorers?league=$league&season=2023";
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

  static Future<List<PlayerStats>> topAssists(String league) async {
    String url =
        "https://v3.football.api-sports.io/players/topassists?league=$league&season=2023";

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

  static Future<List<PlayerStats>> yellowCard(String league) async {
    String url =
        "https://v3.football.api-sports.io/players/topyellowcards?league=$league&season=2023";

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

  static Future<List<PlayerStats>> redCard(String league) async {
    String url =
        "https://v3.football.api-sports.io/players/topredcards?league=$league&season=2023";

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

  static Future<List<FixtureData>> getAllMathces(String league) async {
    String url =
        "https://v3.football.api-sports.io/fixtures/?league=$league&season=2023";

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

  static Future<LiveMatchData> getLiveMatchData(int id) async {
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

  static Future<List<FixtureData>> getLiveMatches(String league) async {
    String url =
        "https://v3.football.api-sports.io/fixtures/?league=$league&season=2023&live=all";

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

  static Future<List<FixtureData>> getUpComingMatches(String league) async {
    String url =
        "https://v3.football.api-sports.io/fixtures/?league=$league&season=2023&timezone=Asia/Amman&next=15";

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
}
