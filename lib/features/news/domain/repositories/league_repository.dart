import 'package:dartz/dartz.dart';
import 'package:football_platform/core/errors/failures.dart';
import 'package:football_platform/features/news/data/models/league_models/fixture_data.dart';
import 'package:football_platform/features/news/data/models/league_models/liveFixtures/live_fixture_data.dart';
import 'package:football_platform/features/news/data/models/league_models/player_stats.dart';
import 'package:football_platform/features/news/data/models/league_models/table.dart';

abstract class LeagueRepository {
  Future<Either<Failure,List<TableData>>> getLeagueTable(String leagueId);

  Future<Either<Failure,List<PlayerStats>>> getTopScorers(String leagueId);

  Future<Either<Failure,List<FixtureData>>> getUpcomingMatches(String leagueId);

  Future<Either<Failure,List<FixtureData>>> getLiveMatches(String leagueId);

  Future<Either<Failure,List<FixtureData>>> getAllMatches(String leagueId);

  Future<Either<Failure,LiveMatchData>> fetchLiveMatchData(int fixtureId);


}