import 'package:clean_architecture/core/error/exceptions.dart';
import 'package:clean_architecture/core/platform/network_info.dart';
import 'package:clean_architecture/number_trivia/data/datasource/number_trivia_local_data_source.dart';
import 'package:clean_architecture/number_trivia/data/datasource/number_trivia_remote_data_source.dart';
import 'package:clean_architecture/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture/number_trivia/domain/entity/number_trivia.dart';
import 'package:clean_architecture/core/error/faliure.dart';
import 'package:clean_architecture/number_trivia/domain/repositories/number_trivia_repositories.dart';
import 'package:dartz/dartz.dart';

typedef Future<NumberTrivia> _ConcreteOrRandomChooser();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaLocalDataSource localDataSource;
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, NumberTrivia>> getConcreateNumberTrivia(
      int number) async {
    return await _getNumberTrivia(
      () => remoteDataSource.getConcreteNumberTrivia(number),
    );
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getNumberTrivia(
      () => remoteDataSource.getRandomNumberTrivia(),
    );
  }

  Future<Either<Failure, NumberTrivia>> _getNumberTrivia(
      _ConcreteOrRandomChooser function) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await function();
        await localDataSource
            .cacheLastNumberTrivia(remoteTrivia as NumberTriviaModel);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final cachedTrivia = await localDataSource.getLastNumberTrivia();
        return Right(cachedTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
