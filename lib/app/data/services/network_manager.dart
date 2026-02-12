import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:nurahelp/app/data/services/socket_service.dart';
import 'package:nurahelp/app/utilities/loaders/loaders.dart';

class AppNetworkManager extends GetxController {
  static AppNetworkManager get instance => Get.find();

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final Rx<ConnectivityResult> connectionStatus = ConnectivityResult.none.obs;
  ConnectivityResult? _previousState;
  bool startNetworkUpdate = false;

  @override
  void onInit() {
    super.onInit();
    // _initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectivity,
    );
  }

  // Future<void> _initConnectivity() async {
  //   final results = await _connectivity.checkConnectivity();
  //   _updateConnectivity(results);
  // }

  Future<void> _updateConnectivity(List<ConnectivityResult> conn) async {
    connectionStatus.value = conn.isNotEmpty
        ? conn.first
        : ConnectivityResult.none;

    bool hasInternet =
        conn.contains(ConnectivityResult.mobile) ||
        conn.contains(ConnectivityResult.wifi);

    bool hadInternet =
        _previousState == ConnectivityResult.mobile ||
        _previousState == ConnectivityResult.wifi;

    // Lost internet
    if (!hasInternet && hadInternet || !hasInternet) {
      startNetworkUpdate = true;
      AppToasts.warningSnackBar(
        title: 'No Internet Connection',
        message: 'Connect to the internet to continue',
      );
      // _previousState = connectionStatus.value;
    }

    // Internet restored
    if (hasInternet && !hadInternet && startNetworkUpdate == true) {
      AppToasts.successSnackBar(
        title: 'Internet Connection is Back',
        message: 'The internet has been restored',
      );

      // Reconnect socket when internet is restored
      try {
        final socketService = Get.find<SocketService>();
        socketService.reconnect();
      } catch (_) {
        // SocketService not initialized yet, ignore
      }
    }

    // Save actual current state for next comparison
    _previousState = connectionStatus.value;
  }

  Future<bool> isConnected() async {
    try {
      final results = await _connectivity
          .checkConnectivity(); // List<ConnectivityResult>
      return results.contains(ConnectivityResult.mobile) ||
          results.contains(ConnectivityResult.wifi);
    } catch (e) {
      return false;
    }
  }
}
