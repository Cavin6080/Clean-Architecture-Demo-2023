import 'package:clean_architecture/core/network/network_info.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  late NetworkInfo networkInfo;
  late MockDataConnectionChecker dataConnectionChecker;
  setUp(() {
    dataConnectionChecker = MockDataConnectionChecker();
    networkInfo = NetWorkInfoImpl(dataConnectionChecker);
  });

  group('internet connectivity checker', () {
    test('should return future variable for the internet status', () {
      //arrange
      final tHasConnectionFuture = Future.value(true);

      when(() => networkInfo.isConnected)
          .thenAnswer((_) => tHasConnectionFuture);

      //act
      final result = networkInfo.isConnected;

      //assert
      verify(() => dataConnectionChecker.hasConnection);
      expect(result, tHasConnectionFuture);
    });
  });
}
