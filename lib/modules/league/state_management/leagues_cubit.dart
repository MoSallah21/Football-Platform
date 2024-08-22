import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/models/league_models/liveFixtures/live_fixture_data.dart';
import 'package:football_platform/modules/league/state_management/leagues_status.dart';
import 'package:football_platform/shared/network/services/api/api.dart';
import 'package:football_platform/models/league_models/fixture_data.dart';
import 'package:football_platform/models/league_models/player_stats.dart';
import 'package:football_platform/models/league_models/table.dart';

class LeagueCubit extends Cubit<LeagueState> {
  LeagueCubit() : super(AppInitState());

  static LeagueCubit get(context) => BlocProvider.of(context);
//home logic
  late int selectedItem;
  late int index;
  void onTap(int idx) {
    selectedItem = idx;
    emit(ChangeSelectedIndex());
  }
  List<String>titles=['','ترتيب الدوري','هدافي الدوري 2023/2024'];
  late String league;
  List<Widget> pages = [];
//table logic
  late List<TableData> dataTable = [];
  void getTableData(String league) async {
    dataTable = await Api.getLeagueTable(league);
    emit(GetTable());
  }

//most goals logic
  late List<PlayerStats> goals = [];
  void getGoalsData(String league) async {
    goals = await Api.topScorers(league);
    emit(GetGoals());
  }

//fixture logic
  late List<FixtureData> liveMatches = [];
  late List<FixtureData> upcomingMatches = [];
  void getUpcomingData(String league) async {
    upcomingMatches = await Api.getUpComingMatches(league);
    liveMatches = await Api.getLiveMatches(league);
    print(liveMatches.length);
    emit(GetUpComingData());
  }

  List<String> giveString(String s) {
    return s.split(RegExp(r"(?=[A-Z])"));
  }

  List<FixtureData> allMatches = [];
  void getAllMatchesData(String league) async {
    allMatches = await Api.getAllMathces(league);
    emit(GetAllMatches());
  }

  //match details
  late TabController tabController;
  int tabIndex = 0;
  bool receivedData = false;
  late LiveMatchData lmd = LiveMatchData();
  void fetchData(FixtureData data) async {
    lmd = await Api.getLiveMatchData(data.fixture.id);
    receivedData = true;
    tabIndex = tabController.index;
    emit(GetLiveMatchData());
  }

}
