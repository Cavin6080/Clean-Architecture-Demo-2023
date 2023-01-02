import 'package:clean_architecture/number_trivia/domain/entity/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  final int mnumber;
  final String mtext;
  const NumberTriviaModel({
    required this.mnumber,
    required this.mtext,
  }) : super(
          number: mnumber,
          text: mtext,
        );

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
      mtext: json['text'],
      mnumber: (json['number'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = mtext;
    data['number'] = mnumber;
    return data;
  }
}
