part of 'league_bloc.dart';


abstract class LeagueState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppInitState extends LeagueState {}

class ChangeSelectedIndex extends LeagueState {}

class LoadingState extends LeagueState {
  final LoadingType loadingType;
  LoadingState({this.loadingType = LoadingType.general});
}
class ErrorState extends LeagueState {
  final String message;
  final ErrorType errorType;
  final VoidCallback? retryAction;
  ErrorState(
      this.message, {
        this.errorType = ErrorType.general,
        this.retryAction,
      });


  @override
  List<Object> get props => [message,errorType];
}

class GetTable extends LeagueState {}

class GetGoals extends LeagueState {}

class GetUpComingData extends LeagueState {}
class DataCleared extends LeagueState {
  @override
  List<Object> get props => [];
}
class GetLiveData extends LeagueState {}

class GetAllMatches extends LeagueState {}

class GetLiveMatchData extends LeagueState {}


class CacheCleared extends LeagueState {}