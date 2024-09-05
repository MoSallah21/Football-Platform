import 'package:football_platform/core/network/network_info.dart';
import 'package:football_platform/features/blogs/data/datasources/local/blog_local_datasource.dart';
import 'package:football_platform/features/blogs/data/datasources/remote/blog_remote_datasource.dart';
import 'package:football_platform/features/blogs/data/repositories/blog_repository_imp.dart';
import 'package:football_platform/features/blogs/domain/repositories/blog_repository.dart';
import 'package:football_platform/features/blogs/domain/usecases/get_all_blogs.dart';
import 'package:football_platform/features/blogs/presentation/bloc/blog_bloc.dart';
import 'package:football_platform/features/game/data/datasources/remote/quiz_remote_datasource.dart';
import 'package:football_platform/features/game/data/repositories/quiz_repository_imp.dart';
import 'package:football_platform/features/game/domain/repositories/quiz_repository.dart';
import 'package:football_platform/features/game/domain/usecases/get_all_questions.dart';
import 'package:football_platform/features/game/presentation/bloc/quiz_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
final sl=GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(
    internetConnectionChecker: sl(),
  ));


  sl.registerLazySingleton(() => InternetConnectionChecker());

  // DataSources
  // blog
  sl.registerLazySingleton<BlogRemoteDatasource>(() => BlogRemoteDataSourceImp());

  sl.registerLazySingleton<BlogLocalDatasource>(() => BlogLocalDatasourceImpl());

  //  quiz
  sl.registerLazySingleton<QuizRemoteDatasource>(() => QuizRemoteDatasourceImp());



  // Repository
  // BlogRepository
  sl.registerLazySingleton<BlogRepository>(() => BlogRepositoryImp(
    remoteDatasource: sl(),
    localDatasource: sl(),
    networkInfo: sl(),
  ));

  // QuizRepository
  sl.registerLazySingleton<QuizRepository>(() => QuizRepositoryImp(
    remoteDatasource: sl(),
    networkInfo: sl(),
  ));


  // UseCases
  // Blogs
  sl.registerLazySingleton(() => GetAllBlogsUseCase(sl()));
  // Quiz
  sl.registerLazySingleton(() => GetAllQuestionsUseCase(sl()));


  // Bloc
  //Blogs
  sl.registerFactory(() => BlogBloc(getAllBlogs: sl()));
  //Quiz
  sl.registerFactory(() => QuizBloc(getAllQuestions: sl()));

}
