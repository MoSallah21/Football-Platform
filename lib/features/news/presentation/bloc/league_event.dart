part of 'league_bloc.dart';

abstract class LeagueEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppStarted extends LeagueEvent {}

class SelectIndexEvent extends LeagueEvent {
  final int index;

  SelectIndexEvent(this.index);

  @override
  List<Object> get props => [index];
}

class GetTableDataEvent extends LeagueEvent {
  final String league;

  GetTableDataEvent(this.league);

  @override
  List<Object> get props => [league];
}

class GetGoalsDataEvent extends LeagueEvent {
  final String league;

  GetGoalsDataEvent(this.league);

  @override
  List<Object> get props => [league];
}

class GetUpcomingDataEvent extends LeagueEvent {
  final String league;

  GetUpcomingDataEvent(this.league);

  @override
  List<Object> get props => [league];
}

class GetLiveMatchEvent extends LeagueEvent {
  final String league;

  GetLiveMatchEvent(this.league);

  @override
  List<Object> get props => [league];
}

class GetAllMatchesDataEvent extends LeagueEvent {
  final String league;

  GetAllMatchesDataEvent(this.league);

  @override
  List<Object> get props => [league];
}

class FetchLiveMatchDataEvent extends LeagueEvent {
  final FixtureData fixtureData;

  FetchLiveMatchDataEvent(this.fixtureData);

  @override
  List<Object> get props => [fixtureData];
}
class ChangeLeagueEvent extends LeagueEvent {
  final String newLeague;

   ChangeLeagueEvent(this.newLeague);

  @override
  List<Object> get props => [newLeague];
}

// Event لتصفير جميع البيانات
class ClearAllDataEvent extends LeagueEvent {
   ClearAllDataEvent();

  @override
  List<Object> get props => [];
}

class RefreshDataEvent extends LeagueEvent {
  final String league;
  final DataType dataType;
  RefreshDataEvent(this.league, this.dataType);
}
class ClearCacheEvent extends LeagueEvent {}

