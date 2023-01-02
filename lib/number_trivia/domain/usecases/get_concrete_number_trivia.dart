import 'package:clean_architecture/core/error/faliure.dart';
import 'package:clean_architecture/core/usecases/usecase.dart';
import 'package:clean_architecture/number_trivia/domain/entity/number_trivia.dart';
import 'package:clean_architecture/number_trivia/domain/repositories/number_trivia_repositories.dart';
import 'package:dartz/dartz.dart';

class GetConcreateNumberTrivia implements UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;
  GetConcreateNumberTrivia(this.repository);

  @override
  Future<Either<Faliure, NumberTrivia>> call(Params params) async {
    return await repository.getConcreateNumberTrivia(params.number);
  }

  // Future<Either<Faliure, NumberTrivia>> call({required int number}) async {
  //   return await repository.getConcreateNumberTrivia(number);
  // }
}

class Params {
  final int number;
  Params({required this.number});
}
