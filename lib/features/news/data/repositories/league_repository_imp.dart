import 'package:dartz/dartz.dart';
import 'package:football_platform/core/errors/failures.dart';
import 'package:football_platform/features/news/data/models/league_models/fixture_data.dart';
import 'package:football_platform/features/news/data/models/league_models/liveFixtures/live_fixture_data.dart';
import 'package:football_platform/features/news/data/models/league_models/player_stats.dart';
import 'package:football_platform/features/news/data/models/league_models/table.dart';
import 'package:football_platform/features/news/domain/repositories/league_repository.dart';

 class LeagueRepositoryImp extends LeagueRepository {
  @override
  Future<Either<Failure, List<FixtureData>>> getAllMatches(String leagueId) {
    // TODO: implement getAllMatches
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<TableData>>> getLeagueTable(String leagueId) {
    // TODO: implement getLeagueTable
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, LiveMatchData>> fetchLiveMatchData(int fixtureId) {
    // TODO: implement getLiveMatchData
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<FixtureData>>> getLiveMatches(String leagueId) {
    // TODO: implement getLiveMatches
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<PlayerStats>>> getTopScorers(String leagueId) {
    // TODO: implement getTopScorers
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<FixtureData>>> getUpcomingMatches(String leagueId) {
    // TODO: implement getUpComingMatches
    throw UnimplementedError();
  }



}