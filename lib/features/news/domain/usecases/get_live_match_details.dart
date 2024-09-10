import 'package:dartz/dartz.dart';
import 'package:football_platform/core/errors/failures.dart';
import 'package:football_platform/features/news/data/models/league_models/liveFixtures/live_fixture_data.dart';
import 'package:football_platform/features/news/domain/repositories/league_repository.dart';


class FetchLiveMatchesDataUseCase{
  final LeagueRepository repository;

  FetchLiveMatchesDataUseCase(this.repository);

  Future<Either<Failure,LiveMatchData>> call (int fixtureId) async
  => await repository.fetchLiveMatchData(fixtureId);

}