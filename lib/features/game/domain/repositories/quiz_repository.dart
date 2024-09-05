import 'package:dartz/dartz.dart';
import 'package:football_platform/core/errors/failures.dart';
import 'package:football_platform/features/blogs/domain/entities/blog.dart';
import 'package:football_platform/features/game/domain/entities/question.dart';

abstract class QuizRepository {
  Future<Either<Failure,List<Question>>> getAllQuestions(int level);
}