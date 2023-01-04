import 'package:clean_architecture/core/error/exceptions.dart';
import 'package:clean_architecture/core/error/faliure.dart';
import 'package:clean_architecture/core/platform/network_info.dart';
import 'package:clean_architecture/number_trivia/data/datasource/number_trivia_local_data_source.dart';
import 'package:clean_architecture/number_trivia/data/datasource/number_trivia_remote_data_source.dart';
import 'package:clean_architecture/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture/number_trivia/domain/entity/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockRemoteDataSource remoteDataSource;
  late MockLocalDataSource localDataSource;
  late MockNetworkInfo networkInfo;
  setUp(() {
    remoteDataSource = MockRemoteDataSource();
    localDataSource = MockLocalDataSource();
    networkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );
  });

  group('device is online', () {
    setUp(() {
      when(() => networkInfo.isConnected).thenAnswer(
        (_) async => true,
      );
    });
    //arrange
    const tNumber = 1;
    const tNumberTriviaModel = NumberTriviaModel(mnumber: 1, mtext: 'test');
    const NumberTrivia tNumberTriva = tNumberTriviaModel;

    test('should throw an error if return is 404', () async {
      //arrange
      when(() => remoteDataSource.getConcreteNumberTrivia(tNumber))
          .thenThrow(ServerException());

      //act
      final result = await repository.getConcreateNumberTrivia(tNumber);

      //assert
      verify(() => remoteDataSource.getConcreteNumberTrivia(tNumber));
      verifyZeroInteractions(localDataSource);
      expect(result, equals(Left(ServerFailure())));
    });

    test(
        'should check the device is online and return remote data source if online',
        () async {
      when(() => remoteDataSource.getConcreteNumberTrivia(tNumber)).thenAnswer(
        (_) async => tNumberTriviaModel,
      );

      when(() => localDataSource.cacheLastNumberTrivia(tNumberTriviaModel))
          .thenAnswer(
        (_) async => tNumberTriviaModel,
      );

      //act
      final result = await repository.getConcreateNumberTrivia(tNumber);

      //assert
      verify(() => networkInfo.isConnected);
      verify(() => localDataSource.cacheLastNumberTrivia(tNumberTriviaModel));
      expect(result, equals(const Right(tNumberTriva)));
    });

    test('should check the device is offline', () async {
      //arrange
      const tNumber = 1;
      const tNumberTriviaModel = NumberTriviaModel(mnumber: 1, mtext: 'test');

      when(() => networkInfo.isConnected).thenAnswer(
        (_) async => false,
      );

      when(() => localDataSource.getLastNumberTrivia())
          .thenThrow(CacheException());

      //act
      final result = await repository.getConcreateNumberTrivia(tNumber);

      //assert
      // verify(() => networkInfo.isConnected);
      expect(result, equals(Left(CacheFailure())));
    });
  });

  group('device is offline', () {
    setUp(() {
      when(() => networkInfo.isConnected).thenAnswer(
        (_) async => false,
      );
    });

    const tNumber = 1;
    const tNumberTriviaModel = NumberTriviaModel(mnumber: 1, mtext: 'test');
    const NumberTrivia tNumberTriva = tNumberTriviaModel;
    test('should return last locally cached data when the device is offline',
        () async {
      //arrange
      when(() => localDataSource.getLastNumberTrivia()).thenAnswer(
        (_) async => tNumberTriviaModel,
      );

      //act
      final result = await repository.getConcreateNumberTrivia(tNumber);

      //assert
      verifyZeroInteractions(remoteDataSource);
      verify(() => localDataSource.getLastNumberTrivia());
      expect(result, equals(const Right(tNumberTriviaModel)));
    });

    test('should return cache faliure when there is nothing to cache',
        () async {
      //arrange
      when(() => localDataSource.getLastNumberTrivia()).thenThrow(
        CacheException(),
      );

      //act
      final result = await repository.getConcreateNumberTrivia(tNumber);

      //assert
      verifyZeroInteractions(remoteDataSource);
      verify(() => localDataSource.getLastNumberTrivia());
      expect(result, equals(Left(CacheFailure())));
    });
  });
}
