// // lib/services/notification_service.dart
// import 'dart:convert';
// import 'dart:async';
// import 'package:signalr_netcore/signalr_client.dart';
// import 'package:hive/hive.dart';
// import '../models/notification_item.dart';
// import 'api_service.dart';

// class NotificationService {
//   late HubConnection _hubConnection;
//   Function(NotificationItem message)? onNotificationReceived;
//   bool _isConnected = false;
//   late String userId;

//   //  for messages that failed to send
//   final List<NotificationItem> _pendingMessages = [];
//   Timer? _retryTimer;

//   /// Connect to SignalR Hub
//   Future<void> connect({required String userId}) async {
//     this.userId = userId;

//     final serverUrl = "http://localhost:5000/notificationHub?userId=$userId";

//     _hubConnection = HubConnectionBuilder().withUrl(serverUrl).build();

//     // Listen to incoming notifications
//     _hubConnection.on("ReceiveNotification", (arguments) {
//       print("Received notification: $arguments");

//       if (arguments != null && arguments.isNotEmpty) {
//         final arg0 = arguments[0];
//         Map<String, dynamic> messageMap = {};

//         if (arg0 is Map) {
//           messageMap = Map<String, dynamic>.from(arg0.cast<String, dynamic>());
//         } else if (arg0 is String) {
//           try {
//             messageMap = jsonDecode(arg0) as Map<String, dynamic>;
//           } catch (e) {
//             print("Failed to decode JSON: $e");

//             messageMap = {
//               'id': DateTime.now().millisecondsSinceEpoch.toString(),
//               'title': arg0.toString(),
//               'subtitle': '',
//               'timestamp': DateTime.now().toIso8601String(),
//               'isRead': false,
//               'category': 'today',
//             };
//           }
//         }

//         final notification = NotificationItem(
//           id: messageMap['id'] ??
//               DateTime.now().millisecondsSinceEpoch.toString(),
//           title: messageMap['title'] ??
//               messageMap['subject'] ??
//               'New Notification',
//           subtitle: messageMap['subtitle'] ??
//               messageMap['subTitle'] ??
//               messageMap['content'] ??
//               '',
//           timestamp: DateTime.tryParse(messageMap['timestamp'] ?? '') ??
//               DateTime.now(),
//           isRead: messageMap['isRead'] ?? false,
//           category:
//               messageMap['category'] ?? _determineCategory(DateTime.now()),
//         );

//         _saveToLocal(notification);
//         onNotificationReceived?.call(notification);
//       }
//     });

//     _hubConnection.onclose((error) {
//       print("SignalR connection closed: $error");
//       _isConnected = false;

//       _attemptReconnection();
//     });

//     await _startConnectionWithRetry();

//     await _fetchMissedNotifications();

//     _startPendingMessageRetry();
//   }

//   void _attemptReconnection() {
//     Timer.periodic(const Duration(seconds: 5), (timer) async {
//       if (_isConnected) {
//         timer.cancel();
//         return;
//       }

//       try {
//         print("Attempting to reconnect to SignalR...");
//         await _hubConnection.start();
//         _isConnected = true;
//         print("Reconnected to SignalR successfully");
//         timer.cancel();

//         _sendPendingMessages();
//       } catch (e) {
//         print("Reconnection attempt failed: $e");
//       }
//     });
//   }

//   String _determineCategory(DateTime timestamp) {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final yesterday = today.subtract(const Duration(days: 1));
//     final notificationDate =
//         DateTime(timestamp.year, timestamp.month, timestamp.day);

//     if (notificationDate.isAtSameMomentAs(today)) {
//       return 'today';
//     } else if (notificationDate.isAtSameMomentAs(yesterday)) {
//       return 'yesterday';
//     } else {
//       return 'friday';
//     }
//   }

//   /// Retry connection to Hub
//   Future<void> _startConnectionWithRetry() async {
//     const maxRetries = 5;
//     int attempt = 0;

//     while (!_isConnected && attempt < maxRetries) {
//       try {
//         await _hubConnection.start();
//         _isConnected = true;
//         print("Connected to NotificationHub as $userId");

//         // Send any pending messages after successful connection
//         _sendPendingMessages();
//       } catch (e) {
//         attempt++;
//         print(
//             "Connection failed, retrying in 5s... attempt $attempt. Error: $e");
//         await Future.delayed(const Duration(seconds: 5));
//       }
//     }

//     if (!_isConnected) {
//       print("Failed to connect after $maxRetries attempts");
//     }
//   }

//   /// Disconnect from Hub
//   Future<void> disconnect() async {
//     _retryTimer?.cancel();
//     if (_isConnected) {
//       await _hubConnection.stop();
//     }
//     _isConnected = false;
//   }

//   /// Fetch missed notifications from API
//   Future<void> _fetchMissedNotifications() async {
//     try {
//       final missed = await ApiService.getMissedNotifications(userId);
//       print("Fetched ${missed.length} missed notifications");
//       for (var msg in missed) {
//         final notification = NotificationItem.fromMap(msg);
//         await _saveToLocal(notification);
//         onNotificationReceived?.call(notification);
//       }
//     } catch (e) {
//       print("Error fetching missed notifications: $e");
//     }
//   }

//   Future<void> _saveToLocal(NotificationItem notification) async {
//     try {
//       final box = await Hive.openBox<NotificationItem>('notifications');
//       await box.put(notification.id, notification);
//       print("Saved notification locally: ${notification.title}");
//     } catch (e) {
//       print("Error saving notification locally: $e");
//     }
//   }

//   /// Load notifications from local storage
//   Future<List<NotificationItem>> loadFromLocal() async {
//     try {
//       final box = await Hive.openBox<NotificationItem>('notifications');
//       final notifications = box.values.toList();

//       // Sort by timestamp (newest first)
//       notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));

//       print("Loaded ${notifications.length} notifications from local storage");
//       return notifications;
//     } catch (e) {
//       print("Error loading notifications from local storage: $e");
//       return [];
//     }
//   }

//   /// Send notification to server
//   Future<void> sendNotification(NotificationItem message) async {
//     if (!_isConnected) {
//       print("Not connected, adding message to pending queue");
//       _pendingMessages.add(message);
//       return;
//     }

//     try {
//       await _hubConnection.invoke("SendNotification", args: [message.toMap()]);
//       print("Notification sent successfully: ${message.title}");
//     } catch (e) {
//       print("Send failed, adding message to pending queue: $e");
//       _pendingMessages.add(message);
//     }
//   }

//   void _startPendingMessageRetry() {
//     _retryTimer?.cancel();
//     _retryTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
//       await _sendPendingMessages();
//     });
//   }

//   /// Send all pending messages
//   Future<void> _sendPendingMessages() async {
//     if (!_isConnected || _pendingMessages.isEmpty) return;

//     print("Attempting to send ${_pendingMessages.length} pending messages");

//     for (var msg in List.from(_pendingMessages)) {
//       try {
//         await _hubConnection.invoke("SendNotification", args: [msg.toMap()]);
//         _pendingMessages.remove(msg);
//         print("Pending message sent successfully: ${msg.title}");
//       } catch (e) {
//         print("Failed to send pending message: $e");
//       }
//     }
//   }

//   /// Mark notification as read
//   Future<void> markAsRead(String notificationId) async {
//     try {
//       final box = await Hive.openBox<NotificationItem>('notifications');
//       final notification = box.get(notificationId);

//       if (notification != null) {
//         final updatedNotification = notification.copyWith(isRead: true);
//         await box.put(notificationId, updatedNotification);
//         print("Marked notification as read: $notificationId");
//       }
//     } catch (e) {
//       print("Error marking notification as read: $e");
//     }
//   }

//   /// Clear all notifications
//   Future<void> clearAllNotifications() async {
//     try {
//       final box = await Hive.openBox<NotificationItem>('notifications');
//       await box.clear();
//       print("All notifications cleared");
//     } catch (e) {
//       print("Error clearing notifications: $e");
//     }
//   }
// }
