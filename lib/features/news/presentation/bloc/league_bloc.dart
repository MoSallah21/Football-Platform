import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:football_platform/features/news/data/models/league_models/fixture_data.dart';
import 'package:football_platform/features/news/data/models/league_models/liveFixtures/live_fixture_data.dart';
import 'package:football_platform/features/news/data/models/league_models/player_stats.dart';
import 'package:football_platform/features/news/data/models/league_models/table.dart';
import 'package:football_platform/shared/network/services/api/api.dart';

part 'league_event.dart';
part 'league_state.dart';

class LeagueBloc extends Bloc<LeagueEvent, LeagueState> {
  LeagueBloc() : super(AppInitState()) {
    on<AppStarted>((event, emit) {
      emit(AppInitState());
    });

    on<SelectIndexEvent>((event, emit) {
      selectedItem = event.index;
      emit(ChangeSelectedIndex());
    });

    on<GetTableDataEvent>((event, emit) async {
      dataTable = await Api.getLeagueTable(event.league);
      emit(GetTable());
    });

    on<GetGoalsDataEvent>((event, emit) async {
      goals = await Api.topScorers(event.league);
      emit(GetGoals());
    });

    on<GetUpcomingDataEvent>((event, emit) async {
      upcomingMatches = await Api.getUpComingMatches(event.league);
      emit(GetUpComingData());
    });

    on<GetLiveMatchEvent>((event, emit) async {
      liveMatches = await Api.getLiveMatches(event.league);
      emit(GetLiveData());
    });

    on<GetAllMatchesDataEvent>((event, emit) async {
      allMatches = await Api.getAllMatches(event.league);
      emit(GetAllMatches());
    });

    on<FetchLiveMatchDataEvent>((event, emit) async {
      lmd = await Api.getLiveMatchData(event.fixtureData.fixture.id);
      receivedData = true;
      emit(GetLiveMatchData());
    });
  }

  late int selectedItem;
  late int index;
  List<String> titles = ['', 'Standings', 'Top Scorer 2023/2024'];
  late String league;
  List<Widget> pages = [];

  // Logic variables
  late List<TableData> dataTable = [];
  late List<PlayerStats> goals = [];
  late List<FixtureData> liveMatches = [];
  late List<FixtureData> upcomingMatches = [];
  late List<FixtureData> allMatches = [];
  late LiveMatchData lmd = LiveMatchData();
  bool receivedData = false;

  // Tab Controller (if required)
  late TabController tabController;
  int tabIndex = 0;
}
