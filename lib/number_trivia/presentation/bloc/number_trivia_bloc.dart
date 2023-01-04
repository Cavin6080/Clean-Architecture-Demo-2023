import 'package:bloc/bloc.dart';
import 'package:clean_architecture/number_trivia/domain/entity/number_trivia.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  NumberTriviaBloc() : super(Empty()) {
    on<NumberTriviaEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
