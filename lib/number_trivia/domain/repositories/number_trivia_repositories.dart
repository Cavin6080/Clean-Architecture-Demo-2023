import 'package:clean_architecture/core/error/faliure.dart';
import 'package:clean_architecture/number_trivia/domain/entity/number_trivia.dart';
import 'package:dartz/dartz.dart';

abstract class NumberTriviaRepository {
  Future<Either<Faliure, NumberTrivia>> getConcreateNumberTrivia(int? number);
  Future<Either<Faliure, NumberTrivia>> getRandomNumberTrivia();
}
