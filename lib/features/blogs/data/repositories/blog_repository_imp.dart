import 'package:dartz/dartz.dart';
import 'package:football_platform/core/errors/exception.dart';
import 'package:football_platform/core/errors/failures.dart';
import 'package:football_platform/core/network/network_info.dart';
import 'package:football_platform/features/blogs/data/datasources/local/blog_local_datasource.dart';
import 'package:football_platform/features/blogs/data/datasources/remote/blog_remote_datasource.dart';
import 'package:football_platform/features/blogs/domain/entities/blog.dart';
import 'package:football_platform/features/blogs/domain/repositories/blog_repository.dart';

 class BlogRepositoryImp implements BlogRepository {
   final BlogRemoteDatasource remoteDatasource;
   final BlogLocalDatasource localDatasource;
   final NetworkInfo networkInfo;


   BlogRepositoryImp({required this.remoteDatasource,required this.networkInfo,required this.localDatasource});
   @override
   @override
   Future<Either<Failure, List<Blog>>> getAllBlogs() async {
     if (await networkInfo.isConnected) {
       try {
         final remoteBlogs = await remoteDatasource.getAllBlogs();
         localDatasource.cacheBlogs(remoteBlogs);
         return Right(remoteBlogs);
       } on ServerException {
         return Left(ServerFailure());
       }
     }
     else {
       try {
         final localBlogs = await localDatasource.getCachedBlogs();
         return Right(localBlogs);
       } on EmptyCacheException {
         return Left(EmptyCacheFailure());
       }
     }
   }}