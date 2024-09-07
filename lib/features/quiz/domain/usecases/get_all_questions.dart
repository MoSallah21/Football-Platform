import 'package:dartz/dartz.dart';
import 'package:football_platform/core/errors/failures.dart';
import 'package:football_platform/features/quiz/domain/entities/question.dart';
import 'package:football_platform/features/quiz/domain/repositories/quiz_repository.dart';


class GetAllQuestionsUseCase{
  final QuizRepository repository;

  GetAllQuestionsUseCase(this.repository);

  Future<Either<Failure,List<Question>>> call (int level) async
  => await repository.getAllQuestions(level);

}