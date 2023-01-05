import 'package:clean_architecture/core/network/network_info.dart';
import 'package:clean_architecture/core/presentation/util/input_converter.dart';
import 'package:clean_architecture/number_trivia/data/datasource/number_trivia_local_data_source.dart';
import 'package:clean_architecture/number_trivia/data/datasource/number_trivia_remote_data_source.dart';
import 'package:clean_architecture/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture/number_trivia/domain/repositories/number_trivia_repositories.dart';
import 'package:clean_architecture/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  //Bloc
  sl.registerFactory(
    () => NumberTriviaBloc(
      concrete: sl(),
      random: sl(),
      inputConverter: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetConcreateNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  // Repository
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  //! Core
  sl.registerLazySingleton(() => InputConverter());

  // Data sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(sl()),
  );

  //! External
  sl.registerLazySingleton<NetworkInfo>(() => NetWorkInfoImpl(sl()));
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
