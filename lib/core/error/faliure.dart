import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final List<dynamic> faliureList;
  const Failure([this.faliureList = const []]);

  @override
  List<Object?> get props => [faliureList];
}

// General failures
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}
