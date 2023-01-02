import 'dart:convert';

import 'package:clean_architecture/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(mnumber: 1, mtext: 'Test Text');

  group('from json', () {
    test('should return a valid model when JSON number is and integer',
        () async {
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double.json'));
      final result = NumberTriviaModel.fromJson(jsonMap);
      expect(result, tNumberTriviaModel);
    });

    test('should return a valid json containing the valid data', () async {
      final jsonResult = tNumberTriviaModel.toJson();
      // assert
      final expectedJsonMap = {
        "text": "Test Text",
        "number": 1,
      };
      expect(jsonResult, expectedJsonMap);
    });
  });
}
