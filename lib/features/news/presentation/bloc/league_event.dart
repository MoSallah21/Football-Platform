part of 'league_bloc.dart';

abstract class LeagueEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppStarted extends LeagueEvent {}

class SelectIndexEvent extends LeagueEvent {
  final int index;
  SelectIndexEvent(this.index);
}

class GetTableDataEvent extends LeagueEvent {
  final String league;
  GetTableDataEvent(this.league);
}

class GetGoalsDataEvent extends LeagueEvent {
  final String league;
  GetGoalsDataEvent(this.league);
}

class GetUpcomingDataEvent extends LeagueEvent {
  final String league;
  GetUpcomingDataEvent(this.league);
}
class GetLiveMatchEvent extends LeagueEvent {
  final String league;
  GetLiveMatchEvent(this.league);
}

class GetAllMatchesDataEvent extends LeagueEvent {
  final String league;
  GetAllMatchesDataEvent(this.league);
}

class FetchLiveMatchDataEvent extends LeagueEvent {
  final FixtureData fixtureData;
  FetchLiveMatchDataEvent(this.fixtureData);
}
