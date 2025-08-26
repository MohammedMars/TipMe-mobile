import 'dart:async';
import 'dart:developer';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:tipme_app/core/dio/service/api-service_path.dart';
import 'package:tipme_app/core/storage/storage_service.dart';
import 'package:tipme_app/viewModels/notificationDataModel.dart';

class SignalRService {
  static SignalRService? _instance;
  static SignalRService get instance => _instance ??= SignalRService._();

  SignalRService._();

  HubConnection? _hubConnection;
  bool _isConnected = false;

  final StreamController<NotificationDataModel> _notificationController =
      StreamController<NotificationDataModel>.broadcast();

  Stream<NotificationDataModel> get notificationStream =>
      _notificationController.stream;

  bool get isConnected => _isConnected;

  Future<void> startConnection() async {
    try {
      final token = await StorageService.get('user_token');
      final userId = await StorageService.get('user_id');

      if (token == null || userId == null) {
        log('SignalR: No token or user ID found');
        return;
      }
      final hubUrl = "${ApiServicePath.notificationHubUrl}?userId=$userId";
      _hubConnection = HubConnectionBuilder()
          .withUrl(hubUrl)
          .withAutomaticReconnect()
          .build();
      _registerEventHandlers();
      await _hubConnection!.start();
      _isConnected = true;

      log('SignalR: Connected successfully for user: $userId');
    } catch (e) {
      log('SignalR: Connection failed: $e');
      _isConnected = false;
    }
  }

  void _registerEventHandlers() {
    if (_hubConnection == null) return;
    _hubConnection!.onclose((error) {
      log('SignalR: Connection closed: $error');
      _isConnected = false;
    } as ClosedCallback);

    _hubConnection!.onreconnecting((error) {
      log('SignalR: Reconnecting: $error');
      _isConnected = false;
    } as ReconnectingCallback);

    _hubConnection!.onreconnected((connectionId) {
      log('SignalR: Reconnected with ID: $connectionId');
      _isConnected = true;
    } as ReconnectedCallback);
    _hubConnection!.on('ReceiveNotification', (arguments) {
      try {
        if (arguments != null && arguments.isNotEmpty) {
          final notificationData = arguments[0] as Map<String, dynamic>;
          final notification = NotificationDataModel.fromJson(notificationData);
          _notificationController.add(notification);
          log('SignalR: Received notification: ${notification.title}');
        }
      } catch (e) {
        log('SignalR: Error parsing notification: $e');
      }
    });
    _hubConnection!.on('ReceiveTipNotification', (arguments) {
      try {
        if (arguments != null && arguments.isNotEmpty) {
          final notificationData = arguments[0] as Map<String, dynamic>;
          final notification = NotificationDataModel.fromJson(notificationData);
          _notificationController.add(notification);
          log('SignalR: Received tip notification: ${notification.title}');
        }
      } catch (e) {
        log('SignalR: Error parsing tip notification: $e');
      }
    });
    _hubConnection!.on('BroadcastNotification', (arguments) {
      try {
        if (arguments != null && arguments.isNotEmpty) {
          final notificationData = arguments[0] as Map<String, dynamic>;
          final notification = NotificationDataModel.fromJson(notificationData);
          _notificationController.add(notification);
          log('SignalR: Received broadcast notification: ${notification.title}');
        }
      } catch (e) {
        log('SignalR: Error parsing broadcast notification: $e');
      }
    });
  }

  Future<void> stopConnection() async {
    try {
      if (_hubConnection != null) {
        await _hubConnection!.stop();
        _isConnected = false;
        log('SignalR: Connection stopped');
      }
    } catch (e) {
      log('SignalR: Error stopping connection: $e');
    }
  }

  Future<void> reconnect() async {
    await stopConnection();
    await Future.delayed(const Duration(seconds: 2));
    await startConnection();
  }

  void dispose() {
    _notificationController.close();
    stopConnection();
  }
}
