import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkInfo {
  NetworkInfo(this._connectivity);

  final Connectivity _connectivity;

  Stream<bool> watchConnection() {
    return _connectivity.onConnectivityChanged.map(
      (results) => results.any((item) => item != ConnectivityResult.none),
    );
  }

  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return results.any((item) => item != ConnectivityResult.none);
  }
}
