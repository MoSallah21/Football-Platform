import 'package:dartz/dartz.dart';
import 'package:football_platform/core/errors/failures.dart';
import 'package:football_platform/features/news/data/models/league_models/table.dart';
import 'package:football_platform/features/news/domain/repositories/league_repository.dart';


class GetLeagueTableUseCase{
  final LeagueRepository repository;

  GetLeagueTableUseCase(this.repository);

  Future<Either<Failure,List<TableData>>> call (String leagueId) async
  => await repository.getLeagueTable(leagueId);

}