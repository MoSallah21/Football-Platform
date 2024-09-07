import 'package:dartz/dartz.dart';
import 'package:football_platform/core/errors/exception.dart';
import 'package:football_platform/core/errors/failures.dart';
import 'package:football_platform/core/network/network_info.dart';
import 'package:football_platform/features/quiz/data/datasources/remote/quiz_remote_datasource.dart';
import 'package:football_platform/features/quiz/domain/entities/question.dart';
import 'package:football_platform/features/quiz/domain/repositories/quiz_repository.dart';

 class QuizRepositoryImp implements QuizRepository {
   final QuizRemoteDatasource remoteDatasource;
   final NetworkInfo networkInfo;


   QuizRepositoryImp({required this.remoteDatasource,required this.networkInfo});
   @override
   @override
   Future<Either<Failure, List<Question>>> getAllQuestions(int level) async {
     if (await networkInfo.isConnected) {
       try {
         final remoteQuestions = await remoteDatasource.getAllQuestions(level);
         return Right(remoteQuestions);
       } on ServerException {
         return Left(ServerFailure());
       }
     }
     else {
       return Left(ServerFailure());
     }
   }}