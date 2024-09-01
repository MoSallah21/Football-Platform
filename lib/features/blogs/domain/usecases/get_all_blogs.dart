import 'package:dartz/dartz.dart';
import 'package:football_platform/core/errors/failures.dart';
import 'package:football_platform/features/blogs/domain/entities/blog.dart';
import 'package:football_platform/features/blogs/domain/repositories/blog_repository.dart';


class GetAllBlogsUseCase{
  final BlogRepository repository;

  GetAllBlogsUseCase(this.repository);

  Future<Either<Failure,List<Blog>>> call () async
  => await repository.getAllBlogs();

}