import 'package:dartz/dartz.dart';
import 'package:football_platform/core/errors/failures.dart';
import 'package:football_platform/features/blogs/domain/entities/blog.dart';

abstract class BlogRepository {
  Future<Either<Failure,List<Blog>>> getAllBlogs();
}