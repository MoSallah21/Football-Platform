import 'package:dartz/dartz.dart';
import 'package:football_platform/core/errors/failures.dart';
import 'package:football_platform/features/news/data/models/league_models/player_stats.dart';
import 'package:football_platform/features/news/domain/repositories/league_repository.dart';


class GetTopScoresUseCase{
  final LeagueRepository repository;

  GetTopScoresUseCase(this.repository);

  Future<Either<Failure,List<PlayerStats>>> call (String leagueId) async
  => await repository.getTopScorers(leagueId);

}