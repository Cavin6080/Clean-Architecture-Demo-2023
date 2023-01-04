import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  // final List<dynamic> faliureList;
  // const Failure([this.faliureList = const []]);
  const Failure();

  @override
  // List<Object?> get props => [faliureList];
  List<Object?> get props => [];
}

// General failures
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}
