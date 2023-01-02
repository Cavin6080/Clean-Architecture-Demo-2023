import 'package:clean_architecture/core/error/faliure.dart';
import 'package:clean_architecture/core/usecases/usecase.dart';
import 'package:clean_architecture/number_trivia/domain/entity/number_trivia.dart';
import 'package:clean_architecture/number_trivia/domain/repositories/number_trivia_repositories.dart';
import 'package:dartz/dartz.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository);
  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await repository.getRandomNumberTrivia();
  }
}
