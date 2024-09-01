import 'package:football_platform/core/network/network_info.dart';
import 'package:football_platform/features/blogs/data/datasources/local/blog_local_datasource.dart';
import 'package:football_platform/features/blogs/data/datasources/remote/blog_remote_datesoucre.dart';
import 'package:football_platform/features/blogs/data/repositories/blog_repository_imp.dart';
import 'package:football_platform/features/blogs/domain/repositories/blog_repository.dart';
import 'package:football_platform/features/blogs/domain/usecases/get_all_blogs.dart';
import 'package:football_platform/features/blogs/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
final sl=GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(
    internetConnectionChecker: sl(),
  ));
  print('NetworkInfo registered');


  sl.registerLazySingleton(() => InternetConnectionChecker());
  print('InternetConnectionChecker registered');

  // DataSources
  sl.registerLazySingleton<BlogRemoteDatasource>(() => BlogRemoteDataSourceImp());
  print('BlogRemoteDatasource registered');

  sl.registerLazySingleton<BlogLocalDatasource>(() => BlogLocalDatasourceImpl());
  print('BlogLocalDatasource registered');

  // Repository
  sl.registerLazySingleton<BlogRepository>(() => BlogRepositoryImp(
    remoteDatasource: sl(),
    localDatasource: sl(),
    networkInfo: sl(),
  ));
  print('BlogRepository registered');

  // UseCases
  sl.registerLazySingleton(() => GetAllBlogsUseCase(sl()));
  print('GetAllBlogsUseCase registered');

  // Bloc
  sl.registerFactory(() => BlogBloc(getAllBlogs: sl()));
  print('PostsBloc registered');

}
