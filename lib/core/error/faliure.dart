import 'package:equatable/equatable.dart';

class Faliure extends Equatable {
  final List<dynamic> faliureList;
  const Faliure([this.faliureList = const []]);

  @override
  List<Object?> get props => [faliureList];
}
