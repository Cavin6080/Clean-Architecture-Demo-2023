import 'dart:convert';
import 'dart:math';

import 'package:clean_architecture/core/error/exceptions.dart';
import 'package:clean_architecture/core/error/faliure.dart';
import 'package:clean_architecture/number_trivia/data/datasource/number_trivia_remote_data_source.dart';
import 'package:clean_architecture/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
// import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import '../../../fixtures/fixture_reader.dart';

class MockHttp extends Mock implements Client {}

void main() {
  late final MockHttp client;
  late final NumberTriviaRemoteDataSourceImpl remoteDataSource;
  setUp(() {
    client = MockHttp();
    remoteDataSource = NumberTriviaRemoteDataSourceImpl(client);
  });

  const tNumber = 1;
  final tNumberTriviaModel =
      NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));
  group('concreate number trivia tests', () {
    test('''should return number trivia model 
        when status code is 200 in GET request''', () async {
      //arrange
      when(
        () => client.get(
          Uri.parse('http://numbersapi.com/$tNumber'),
          headers: {'Content-Type': 'application/json'},
        ),
      ).thenAnswer(
        (_) async => Response(
          fixture('trivia.json'),
          200,
        ),
      );

      //act
      final result = await remoteDataSource.getConcreteNumberTrivia(tNumber);

      //assert
      expect(
        result,
        equals(tNumberTriviaModel),
      );
    });

    test('should throw a server exception when status code is not 200',
        () async {
      //arrange
      when(
        () => client.get(
          Uri.parse('http://numbersapi.com/$tNumber'),
          headers: {'Content-Type': 'application/json'},
        ),
      ).thenAnswer(
        (_) async => Response(
          'Something went wrong',
          400,
        ),
      );

      //act
      final call = remoteDataSource.getConcreteNumberTrivia;

      //assert
      expect(
        () => call(tNumber),
        throwsA(
          const TypeMatcher<ServerException>(),
        ),
      );
    });
  });

  group('get random number tests', () {
    test('''should return number trivia model 
        when status code is 200 in GET request''', () async {
      //arrange
      when(
        () => client.get(
          Uri.parse('http://numbersapi.com/random'),
          headers: {'Content-Type': 'application/json'},
        ),
      ).thenAnswer(
        (_) async => Response(
          fixture('trivia.json'),
          200,
        ),
      );

      //act
      final result = await remoteDataSource.getRandomNumberTrivia();

      //assert
      expect(
        result,
        equals(tNumberTriviaModel),
      );
    });

    test('should throw a server exception when status code is not 200',
        () async {
      //arrange
      when(
        () => client.get(
          Uri.parse('http://numbersapi.com/random'),
          headers: {'Content-Type': 'application/json'},
        ),
      ).thenAnswer(
        (_) async => Response(
          'Something went wrong',
          400,
        ),
      );

      //act
      final call = remoteDataSource.getRandomNumberTrivia;

      //assert
      expect(
        () => call(),
        throwsA(
          const TypeMatcher<ServerException>(),
        ),
      );
    });
  });
}
