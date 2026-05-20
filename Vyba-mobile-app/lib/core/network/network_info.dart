import 'package:connectivity_plus/connectivity_plus.dart';

/// Abstraction for checking network connectivity.
abstract class NetworkInfo {
  /// Whether the device currently has an active internet connection.
  Future<bool> get isConnected;

  /// Stream of connectivity changes.
  Stream<List<ConnectivityResult>> get onConnectivityChanged;
}

/// Implementation of [NetworkInfo] using [Connectivity].
class NetworkInfoImpl implements NetworkInfo {
  /// Creates a [NetworkInfoImpl].
  const NetworkInfoImpl(this._connectivity);

  final Connectivity _connectivity;

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;
}
