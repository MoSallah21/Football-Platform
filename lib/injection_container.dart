import 'package:football_platform/core/network/network_info.dart';
import 'package:football_platform/features/blogs/data/datasources/local/blog_local_datasource.dart';
import 'package:football_platform/features/blogs/data/datasources/remote/blog_remote_datasource.dart';
import 'package:football_platform/features/blogs/data/repositories/blog_repository_imp.dart';
import 'package:football_platform/features/blogs/domain/repositories/blog_repository.dart';
import 'package:football_platform/features/blogs/domain/usecases/get_all_blogs.dart';
import 'package:football_platform/features/blogs/presentation/bloc/blog_bloc.dart';
import 'package:football_platform/features/news/data/datasources/remote/league_remote_datasource.dart';
import 'package:football_platform/features/news/data/repositories/league_repository_imp.dart';
import 'package:football_platform/features/news/domain/repositories/league_repository.dart';
import 'package:football_platform/features/news/domain/usecases/get_all_matches.dart';
import 'package:football_platform/features/news/domain/usecases/get_live_match_details.dart';
import 'package:football_platform/features/prediction/data/datasources/remote/predict_remote_datasource.dart';
import 'package:football_platform/features/prediction/data/repositories/predict_repository_imp.dart';
import 'package:football_platform/features/prediction/domain/repositories/predict_repository.dart';
import 'package:football_platform/features/prediction/domain/usecases/predict_result.dart';
import 'package:football_platform/features/prediction/presentation/bloc/predict_bloc.dart';
import 'package:football_platform/features/quiz/data/datasources/remote/quiz_remote_datasource.dart';
import 'package:football_platform/features/quiz/data/repositories/quiz_repository_imp.dart';
import 'package:football_platform/features/quiz/domain/repositories/quiz_repository.dart';
import 'package:football_platform/features/quiz/domain/usecases/get_all_questions.dart';
import 'package:football_platform/features/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'features/news/domain/usecases/get_league_table.dart';
import 'features/news/domain/usecases/get_live_matches.dart';
import 'features/news/domain/usecases/get_top_scorers.dart';
import 'features/news/domain/usecases/get_upcoming_matches.dart';
import 'features/news/presentation/bloc/league_bloc.dart';
final sl=GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(
    internetConnectionChecker: sl(),
  ));

  sl.registerLazySingleton(() => InternetConnectionChecker());

  _registerDataSources();

  _registerRepositories();

  _registerBlocs();

  _registerUseCases();
}
void _registerDataSources(){
  sl.registerLazySingleton<BlogRemoteDatasource>(() => BlogRemoteDataSourceImp());

  sl.registerLazySingleton<BlogLocalDatasource>(() => BlogLocalDatasourceImpl());

  sl.registerLazySingleton<QuizRemoteDatasource>(() => QuizRemoteDatasourceImp());

  sl.registerLazySingleton<PredictRemoteDatasource>(() => PredictRemoteDatasourceImp());

  sl.registerLazySingleton<LeagueRemoteDatasource>(() => LeagueRemoteDatasourceImp());
}
void _registerUseCases(){
  sl.registerLazySingleton(() => GetAllBlogsUseCase(sl()));
  // Quiz
  sl.registerLazySingleton(() => GetAllQuestionsUseCase(sl()));
  // Quiz
  sl.registerLazySingleton(() => PredictUseCase(sl()));

  //News
  sl.registerLazySingleton(() => GetAllMatchesUseCase(sl()));

  sl.registerLazySingleton(() => GetLeagueTableUseCase(sl()));

  sl.registerLazySingleton(() => GetLiveMatchesUseCase(sl()));

  sl.registerLazySingleton(() => GetTopScoresUseCase(sl()));

  sl.registerLazySingleton(() => GetUpcomingUseCase(sl()));

  sl.registerLazySingleton(() => FetchLiveMatchesDataUseCase(sl()));



}
void _registerRepositories(){
  sl.registerLazySingleton<BlogRepository>(() => BlogRepositoryImp(
    remoteDatasource: sl(),
    localDatasource: sl(),
    networkInfo: sl(),
  ));
  sl.registerLazySingleton<QuizRepository>(() => QuizRepositoryImp(
    remoteDatasource: sl(),
    networkInfo: sl(),
  ));
  sl.registerLazySingleton<PredictRepository>(() => PredictRepositoryImp(
      remoteDatasource: sl(),
      networkInfo: sl()));

  sl.registerLazySingleton<LeagueRepository>(() => LeagueRepositoryImp(sl(),sl()));

}
void _registerBlocs(){
  sl.registerFactory(() => BlogBloc(getAllBlogs: sl()));
  sl.registerFactory(() => QuizBloc(getAllQuestions: sl()));
  sl.registerFactory(() => PredictBloc(predict: sl()));
  sl.registerFactory(()=>LeagueBloc(
      getLeagueTableUseCase: sl(),
      getTopScoresUseCase: sl(),
      getUpcomingUseCase: sl(),
    getLiveMatchesUseCase: sl(),
    getAllMatchesUseCase: sl(),
    fetchLiveMatchesDataUseCase: sl(),



  ));
}