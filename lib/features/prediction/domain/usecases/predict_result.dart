import 'package:dartz/dartz.dart';
import 'package:football_platform/core/errors/failures.dart';
import 'package:football_platform/features/prediction/domain/repositories/predict_repository.dart';


class PredictUseCase{
  final PredictRepository repository;

  PredictUseCase(this.repository);

  Future<Either<Failure,Map<String, dynamic>>> call ({
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
    double? awayChances,
}) async
  => await repository.predictResult(
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

}