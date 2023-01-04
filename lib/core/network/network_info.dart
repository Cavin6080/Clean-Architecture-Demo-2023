import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetWorkInfoImpl implements NetworkInfo {
  DataConnectionChecker dataConnectionChecker;
  NetWorkInfoImpl(this.dataConnectionChecker);
  @override
  Future<bool> get isConnected => dataConnectionChecker.hasConnection;
}
