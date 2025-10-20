import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../popups/loaders.dart';

/// Manages the network connectivity status and provides methods to check and handle connectivity changes.
class NetworkManager extends GetxController {
  static NetworkManager get instance => Get.find();

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final Rx<ConnectivityResult> _connectionStatus = ConnectivityResult.none.obs;

  /// Initialize the network manager and set up a stream to continually check the connection status.
  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  /// Initialize connectivity checking
  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Could not check connectivity status: $e');
      }
    }
  }

  /// Update the connection status based on changes in connectivity
  void _updateConnectionStatus(List<ConnectivityResult> results) {
    // Use the first result or check if any connection exists
    final newStatus = results.isNotEmpty ? results.first : ConnectivityResult.none;
    final oldStatus = _connectionStatus.value;

    _connectionStatus.value = newStatus;

    // Show snackbar only when connection is lost (not on initial setup)
    if (oldStatus != ConnectivityResult.none && newStatus == ConnectivityResult.none) {
      TLoaders.warningSnackBar(title: 'No Internet Connection');
    }

    // Show reconnection message when coming back online
    /*if (oldStatus == ConnectivityResult.none && newStatus != ConnectivityResult.none) {
      TLoaders.successSnackBar(title: 'Back Online');
    }*/


  }

  /// Check the internet connection status.
  /// Returns 'true' if connected, 'false' otherwise.
  Future<bool> isConnected() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result.any((connection) =>
      connection != ConnectivityResult.none
      );
    } on PlatformException catch (_) {
      return false;
    }
  }

  /// Get current connectivity status
  ConnectivityResult get connectionStatus => _connectionStatus.value;

  /// Check if currently connected
  bool get isConnectedNow {
    return _connectionStatus.value != ConnectivityResult.none;
  }

  /// Dispose or close the active connectivity stream.
  @override
  void onClose() {
    super.onClose();
    _connectivitySubscription.cancel();
  }
}