import 'dart:async';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:tipme_app/core/storage/storage_service.dart';

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

  factory NotificationHubService() {
    return _instance;
  }

  NotificationHubService._internal();

  Future<void> connectToHub() async {
    if (_isConnecting) return;
    _isConnecting = true;

    try {
      final userId = await StorageService.get('user_id') ?? 'anonymous';
      _serverUrl = "http://localhost:5000/notificationHub?userId=$userId";

      _hubConnection = HubConnectionBuilder()
          .withUrl(_serverUrl,
              options: HttpConnectionOptions(logMessageContent: true))
          .withAutomaticReconnect(
              retryDelays: [2000, 5000, 10000, 30000]).build();

      _setupHubHandlers();

      await _hubConnection.start();
      _retryCount = 0;
      print("Connected to NotificationHub as $userId");
    } catch (e) {
      print("Failed to connect to NotificationHub: $e");
      _scheduleReconnect();
    } finally {
      _isConnecting = false;
    }
  }

  void _setupHubHandlers() {
    _hubConnection.on("ReceiveNotification", (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        try {
          final Map<String, dynamic> data =
              Map<String, dynamic>.from(arguments[0] as Map);
          final subject = data['subject'] ?? "No Title";
          final content = data['content'] ?? "No Content";
          print("Notification received: $subject - $content");
        } catch (e) {
          print("Failed to parse notification: $e");
        }
      }
    });
    _hubConnection.onclose(({Exception? error}) {
      print("Connection closed. Error: $error");
      _scheduleReconnect();
      return;
    });
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
    }
  }
}
