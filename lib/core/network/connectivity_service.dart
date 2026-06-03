import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  Stream<bool> get isConnected => _controller.stream;

  ConnectivityService() {
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      _updateConnectionStatus(results);
    });
    checkConnection();
  }

  Future<bool> checkConnection() async {
    final results = await _connectivity.checkConnectivity();
    final connected = !results.contains(ConnectivityResult.none);
    _controller.add(connected);
    return connected;
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    _controller.add(!results.contains(ConnectivityResult.none));
  }

  void dispose() {
    _controller.close();
  }
}
