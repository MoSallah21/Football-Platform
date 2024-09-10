import 'package:dartz/dartz.dart';
import 'package:football_platform/core/errors/failures.dart';
import 'package:football_platform/features/news/data/models/league_models/fixture_data.dart';
import 'package:football_platform/features/news/domain/repositories/league_repository.dart';


class GetAllMatchesUseCase{
  final LeagueRepository repository;

  GetAllMatchesUseCase(this.repository);

  Future<Either<Failure,List<FixtureData>>> call (String leagueId) async
  => await repository.getAllMatches(leagueId);

}