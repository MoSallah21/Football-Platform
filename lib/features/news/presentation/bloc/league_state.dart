part of 'league_bloc.dart';


abstract class LeagueState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppInitState extends LeagueState {}

//home
class ChangeSelectedIndex extends LeagueState {}

//table
class GetTable extends LeagueState {}

//goals
class GetGoals extends LeagueState {}

//fixture
class GetUpComingData extends LeagueState {}

class GetLiveData extends LeagueState {}


class GetAllMatches extends LeagueState {}

class GetLiveMatchData extends LeagueState {}
