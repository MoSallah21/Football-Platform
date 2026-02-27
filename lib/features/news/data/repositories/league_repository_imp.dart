import 'package:dartz/dartz.dart';
import 'package:football_platform/core/errors/failures.dart';
import 'package:football_platform/core/network/network_info.dart';
import 'package:football_platform/features/news/data/datasources/remote/league_remote_datasource.dart';
import 'package:football_platform/features/news/data/models/league_models/fixture_data.dart';
import 'package:football_platform/features/news/data/models/league_models/liveFixtures/live_fixture_data.dart';
import 'package:football_platform/features/news/data/models/league_models/player_stats.dart';
import 'package:football_platform/features/news/data/models/league_models/table.dart';
import 'package:football_platform/features/news/domain/repositories/league_repository.dart';

import '../../../../core/errors/exception.dart';

 class LeagueRepositoryImp extends LeagueRepository {
   LeagueRepositoryImp(this.leagueRemoteDatasource,this.networkInfo);
   LeagueRemoteDatasource leagueRemoteDatasource;
   NetworkInfo networkInfo;
  @override
  Future<Either<Failure, List<FixtureData>>> getAllMatches(String leagueId)async {
    if (await networkInfo.isConnected) {
      try {
        final remoteLeague = await leagueRemoteDatasource.getAllMatches(leagueId);
        return Right(remoteLeague);
      } on ServerException {
        return Left(ServerFailure());
      }
    }
    return Future.error("No Internet Connection");
  }
  @override
  Future<Either<Failure, List<TableData>>> getLeagueTable(String leagueId)async {
    if (await networkInfo.isConnected) {
      try {
        final remoteLeague = await leagueRemoteDatasource.getLeagueTable(leagueId);
        return Right(remoteLeague);
      } on ServerException {
        return Left(ServerFailure());
      }
    }
    return Future.error("No Internet Connection");
  }

  @override
  Future<Either<Failure, List<FixtureData>>> getLiveMatches(String leagueId)async {
    if (await networkInfo.isConnected) {
      try {
        final remoteLeague = await leagueRemoteDatasource.getLiveMatches(leagueId);
        return Right(remoteLeague);
      } on ServerException {
        return Left(ServerFailure());
      }
    }
    return Future.error("No Internet Connection");
  }

  @override
  Future<Either<Failure, List<PlayerStats>>> getTopScorers(String leagueId)async {
    if (await networkInfo.isConnected) {
      try {
        final remoteLeague = await leagueRemoteDatasource.topScorers(leagueId);
        return Right(remoteLeague);
      } on ServerException {
        return Left(ServerFailure());
      }
    }
    return Future.error("No Internet Connection");
  }

  @override
  Future<Either<Failure, List<FixtureData>>> getUpcomingMatches(String leagueId)async {
    if (await networkInfo.isConnected) {
      try {
        final remoteLeague = await leagueRemoteDatasource.getUpComingMatches(leagueId);
        return Right(remoteLeague);
      } on ServerException {
        return Left(ServerFailure());
      }
    }
    return Future.error("No Internet Connection");
  }

  @override
  Future<Either<Failure, LiveMatchData>> getLiveMatchData(int fixtureId)async {
    if (await networkInfo.isConnected) {
      try {
        final remoteLeague = await leagueRemoteDatasource.getLiveMatchData(fixtureId);
        return Right(remoteLeague);
      } on ServerException {
        return Left(ServerFailure());
      }
    }
    return Future.error("No Internet Connection");
  }

  @override
  Future<Either<Failure, List<PlayerStats>>> getRedCards(String league)async {
    if (await networkInfo.isConnected) {
      try {
        final remoteLeague = await leagueRemoteDatasource.redCard(league);
        return Right(remoteLeague);
      } on ServerException {
        return Left(ServerFailure());
      }
    }
    return Future.error("No Internet Connection");
  }

  @override
  Future<Either<Failure, List<PlayerStats>>> getTopAssists(String leagueId)async {
    if (await networkInfo.isConnected) {
      try {
        final remoteLeague = await leagueRemoteDatasource.topAssists(leagueId);
        return Right(remoteLeague);
      } on ServerException {
        return Left(ServerFailure());
      }
    }
    return Future.error("No Internet Connection");
  }

  @override
  Future<Either<Failure, List<PlayerStats>>> getYellowCards(String league)async {
    if (await networkInfo.isConnected) {
      try {
        final remoteLeague = await leagueRemoteDatasource.yellowCard(league);
        return Right(remoteLeague);
      } on ServerException {
        return Left(ServerFailure());
      }
    }
    return Future.error("No Internet Connection");
  }

}