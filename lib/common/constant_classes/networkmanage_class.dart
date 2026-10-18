// lib/common/services/network_manager.dart
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkManager {
  final Connectivity _connectivity = Connectivity();

  Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Stream<bool> get connectionStream => _connectivity.onConnectivityChanged.map(
    (result) => result != ConnectivityResult.none,
  );
}
