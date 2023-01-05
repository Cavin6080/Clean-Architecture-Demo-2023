// ignore_for_file: constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:clean_architecture/core/error/faliure.dart';
import 'package:clean_architecture/core/presentation/util/input_converter.dart';
import 'package:clean_architecture/core/usecases/usecase.dart';
import 'package:clean_architecture/number_trivia/domain/entity/number_trivia.dart';
import 'package:clean_architecture/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreateNumberTrivia concrete;
  final GetRandomNumberTrivia random;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.concrete,
    required this.random,
    required this.inputConverter,
  }) : super(Empty()) {
    on<GetTriviaForConcreteNumber>((event, emit) async {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);

      final stateResult = await inputEither.fold(
          (failure) async =>
              Future(() => const Error(message: INVALID_INPUT_FAILURE_MESSAGE)),
          (integer) async {
        emit(Loading());
        final failureOrTrivia = await concrete(Params(number: integer));
        return _eitherLoadedOrErrorState(failureOrTrivia);
      });
      emit(stateResult);
    });

    on<GetTriviaForRandomNumber>((event, emit) async {
      emit(Loading());
      final failureOrTrivia = await random(NoParams());
      emit(_eitherLoadedOrErrorState(failureOrTrivia));
    });
  }

  NumberTriviaState _eitherLoadedOrErrorState(
      Either<Failure, NumberTrivia> failureOrTrivia) {
    return failureOrTrivia.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (trivia) => Loaded(trivia: trivia));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected failure';
    }
  }
}
