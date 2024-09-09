import 'package:dartz/dartz.dart';
import 'package:football_platform/core/errors/failures.dart';

abstract class PredictRepository {
  Future<Either<Failure,Map<String, dynamic>>> predictResult({
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
});
}