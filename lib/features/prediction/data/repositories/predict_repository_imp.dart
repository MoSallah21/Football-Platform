import 'package:dartz/dartz.dart';
import 'package:football_platform/core/errors/exception.dart';
import 'package:football_platform/core/errors/failures.dart';
import 'package:football_platform/core/network/network_info.dart';
import 'package:football_platform/features/prediction/data/datasources/remote/predict_remote_datasource.dart';
import 'package:football_platform/features/prediction/domain/repositories/predict_repository.dart';

 class PredictRepositoryImp extends PredictRepository{
   final PredictRemoteDatasource remoteDatasource;
   final NetworkInfo networkInfo;

  PredictRepositoryImp({required this.remoteDatasource ,required this.networkInfo});

  @override
  Future<Either<Failure, Map<String, dynamic>>> predictResult(
  {
    required double mode,
    required double homeCode,
    double? homePoss,
    double? homeShoots,
    double? homeShootsOn,
    double? homeCorners,
    double? homeChances,
    required awayCode,
    double? awayPoss,
    double? awayShoots,
    double? awayShootsOn,
    double? awayCorners,
    double? awayChances,}
      ) async{
    if (await networkInfo.isConnected){
      try{
        final remoteResult = await remoteDatasource.predictResult(
          mode: mode,
          homeCode: homeCode,
          awayCode: awayCode,
          homeChances: homeChances,
          awayChances: awayChances,
          homeCorners: homeCorners,
          awayCorners: awayCorners,
          homePoss: homePoss,
          awayPoss: awayPoss,
          homeShoots: homeShoots,
          awayShoots: awayShoots,
          homeShootsOn: homeShootsOn,
          awayShootsOn: awayShootsOn,
        );
        return Right(remoteResult);
      }
      on ServerException {
        return Left(ServerFailure());
      }
    }
    else {
      return Left(ServerFailure());
    }
  }

}