// lib/services/notification_hub_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:tipme_app/core/storage/storage_service.dart';
import 'package:tipme_app/services/notification_service.dart';

class NotificationHubService {
  static final NotificationHubService _instance =
      NotificationHubService._internal();
  late HubConnection _hubConnection;
  String _serverUrl = "";
  bool _isConnecting = false;
  Timer? _reconnectTimer;
  final List<Duration> _retryDelays = [
    const Duration(seconds: 2),
    const Duration(seconds: 5),
    const Duration(seconds: 10),
    const Duration(seconds: 30),
  ];
  int _retryCount = 0;

  final StreamController<Map<String, dynamic>> _notificationController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get notificationStream =>
      _notificationController.stream;

  factory NotificationHubService() => _instance;

  NotificationHubService._internal();

  Future<void> connectToHub() async {
    if (_isConnecting) return;
    _isConnecting = true;

    try {
      final userId = await StorageService.get('user_id') ?? 'anonymous';
      _serverUrl = "http://localhost:5000/notificationHub?userId=$userId";

      _hubConnection = HubConnectionBuilder()
          .withUrl(_serverUrl,
              options: HttpConnectionOptions(
                logMessageContent: true,
                skipNegotiation: true,
                transport: HttpTransportType.WebSockets,
              ))
          .withAutomaticReconnect(
              retryDelays: [2000, 5000, 10000, 30000]).build();

      _setupHubHandlers();
      await _hubConnection.start();

      _retryCount = 0;
      print("Connected to NotificationHub as $userId");
      await NotificationService.retryPendingNotifications();
    } catch (e) {
      print("Failed to connect to NotificationHub: $e");
      _scheduleReconnect();
    } finally {
      _isConnecting = false;
    }
  }

  void _setupHubHandlers() {
    _hubConnection.on("ReceiveNotification", (arguments) {
      print("Raw notification received: $arguments");

      // Handle null or empty data
      if (arguments == null || arguments.isEmpty || arguments[0] == null) {
        print("Server sent null notification - creating fallback");
        _handleFallbackNotification(reason: 'server_sent_null');
        return;
      }

      // Handle actual data
      try {
        final notificationData = _parseNotificationData(arguments[0]);
        _processValidNotification(notificationData);
      } catch (e) {
        print("Failed to parse notification: $e");
        _handleFallbackNotification(
          reason: 'parse_error',
          rawData: arguments[0]?.toString(),
          error: e,
        );
      }
    });

    _hubConnection.onreconnecting(({Exception? error}) {
      print("Hub reconnecting due to: ${error?.toString() ?? 'unknown error'}");
    });

    _hubConnection.onreconnected(({String? connectionId}) {
      print("Hub reconnected with connectionId: $connectionId");
      _retryCount = 0;
      NotificationService.retryPendingNotifications();
    });

    _hubConnection.onclose(({Exception? error}) {
      print("Connection closed. Error: ${error?.toString() ?? 'No error'}");
      _scheduleReconnect();
    });
  }

  Map<String, dynamic> _parseNotificationData(dynamic rawData) {
    if (rawData is Map) {
      return Map<String, dynamic>.from(rawData);
    } else if (rawData is String) {
      return Map<String, dynamic>.from(json.decode(rawData));
    } else {
      throw FormatException(
          'Unknown notification format: ${rawData.runtimeType}');
    }
  }

  // the notification will recieved without null arguments after mohammed edit the apis, for now i add "_handleFallbackNotification"
  //  to handle the null or empty data from server
  void _handleFallbackNotification({
    required String reason,
    String? rawData,
    dynamic error,
  }) {
    final fallbackNotification = _createFallbackNotification();
    fallbackNotification['fallbackReason'] = reason;
    fallbackNotification['rawData'] = rawData;
    if (error != null) fallbackNotification['error'] = error.toString();

    _storeAndBroadcastNotification(fallbackNotification);
  }

  void _processValidNotification(Map<String, dynamic> notificationData) {
    _enhanceNotificationData(notificationData);
    _storeAndBroadcastNotification(notificationData);

    final title =
        notificationData['title'] ?? notificationData['subject'] ?? 'No Title';
    final content = notificationData['content'] ??
        notificationData['body'] ??
        notificationData['subTitle'] ??
        'No Content';
    print("Notification processed: $title - $content");
  }

  void _storeAndBroadcastNotification(Map<String, dynamic> notification) {
    _storeNotificationLocally(notification);
    _notificationController.add(notification);
  }

  Map<String, dynamic> _createFallbackNotification() {
    return {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': 'New Notification',
      'content': 'You have a new notification from the system',
      'timestamp': DateTime.now().toIso8601String(),
      'isRead': false,
      'isFallback': true,
    };
  }

  void _enhanceNotificationData(Map<String, dynamic> notification) {
    notification['id'] ??= DateTime.now().millisecondsSinceEpoch.toString();
    notification['timestamp'] ??= DateTime.now().toIso8601String();
    notification['isRead'] ??= false;
    notification['clientReceivedAt'] = DateTime.now().toIso8601String();
    notification['clientPlatform'] = 'flutter';
  }

  Future<void> _storeNotificationLocally(
      Map<String, dynamic> notification) async {
    try {
      final userId = await StorageService.get('user_id') ?? 'anonymous';
      List<dynamic> notifications =
          await StorageService.getList('notifications_$userId');

      final existingIndex = notifications
          .indexWhere((n) => n is Map && n['id'] == notification['id']);

      if (existingIndex != -1) {
        notifications[existingIndex] = notification;
      } else {
        notifications.add(notification);
        if (notifications.length > 100) {
          notifications = notifications.sublist(notifications.length - 100);
        }
      }

      await StorageService.setList('notifications_$userId', notifications);

      print("Notification stored locally: ${notification['id']}");
    } catch (e) {
      print("Failed to store notification locally: $e");
    }
  }

  void _scheduleReconnect() {
    if (_retryCount >= _retryDelays.length) {
      print("Max reconnection attempts reached. Giving up.");
      return;
    }

    _reconnectTimer?.cancel();
    final delay = _retryDelays[_retryCount];
    print("Will attempt to reconnect in ${delay.inSeconds} seconds...");

    _reconnectTimer = Timer(delay, () {
      _retryCount++;
      connectToHub();
    });
  }

  Future<void> disconnectFromHub() async {
    _reconnectTimer?.cancel();
    try {
      await _hubConnection.stop();
      print("Disconnected from NotificationHub");
    } catch (e) {
      print("Error disconnecting from NotificationHub: $e");
    } finally {
      if (!_notificationController.isClosed) {
        _notificationController.close();
      }
    }
  }

  // to get the stored notifications
  static Future<List<Map<String, dynamic>>> getStoredNotifications() async {
    try {
      final userId = await StorageService.get('user_id') ?? 'anonymous';
      final notifications =
          await StorageService.getList('notifications_$userId');
      return List<Map<String, dynamic>>.from(notifications);
    } catch (e) {
      print("Error getting stored notifications: $e");
      return [];
    }
  }

  static Future<void> clearStoredNotifications() async {
    try {
      final userId = await StorageService.get('user_id') ?? 'anonymous';
      await StorageService.setList('notifications_$userId', []);
      print("Cleared all stored notifications");
    } catch (e) {
      print("Error clearing stored notifications: $e");
    }
  }

  bool get isConnected => _hubConnection.state == HubConnectionState.Connected;

  HubConnectionState? get connectionState => _hubConnection.state;

  Future<void> manualReconnect() async {
    _retryCount = 0;
    await connectToHub();
  }
}
