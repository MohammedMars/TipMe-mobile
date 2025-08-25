// lib/services/connectivity_service.dart
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:tipme_app/services/notification_hub_service.dart';
import 'package:tipme_app/services/notification_service.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionController =
      StreamController<bool>.broadcast();

  Stream<bool> get connectionStream => _connectionController.stream;
  bool _isConnected = true;

  ConnectivityService() {
    _init();
  }

  Future<void> _init() async {
  
    var result = await _connectivity.checkConnectivity();
    _isConnected = result != ConnectivityResult.none;
    _connectionController.add(_isConnected);

    
    _connectivity.onConnectivityChanged.listen((result) { // listen for the connection changes
      final newState = result != ConnectivityResult.none;
      if (newState != _isConnected) {
        _isConnected = newState;
        _connectionController.add(_isConnected);

        if (_isConnected) { // if it was offline when back online
          NotificationService.retryPendingNotifications();
          NotificationHubService().connectToHub();
        }
      }
    });
  }

  Future<bool> isConnected() async {
    var result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  void dispose() {
    _connectionController.close();
  }
}
