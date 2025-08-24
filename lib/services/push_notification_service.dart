// // lib/services/push_notification_service.dart
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart'; // To check if running on Web

// class PushNotificationService {
//   final FirebaseMessaging _fcm = FirebaseMessaging.instance;

//   Future<void> init() async {
//     try {
//       // Initialization
//       if (!kIsWeb) {
//         // Request permissions (iOS)
//         await _fcm.requestPermission();
//       }

//       // Get FCM Token
//       String? token;
//       if (kIsWeb) {
//         // Web
//         token = await _fcm.getToken(
//           vapidKey: "YOUR_WEB_VAPID_KEY_HERE", // Required for Web
//         );
//       } else {
//         // Mobile
//         token = await _fcm.getToken();
//       }
//       print("FCM Token: $token");

//       // App is in foreground
//       FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//         print("Push Received: ${message.notification?.title}");
//         // TODO: Update the Notifications UI or save the message
//       });

//       // App in background and user tapped on the notification
//       FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//         print("User tapped notification: ${message.notification?.title}");
//         // TODO: Open the appropriate page or update UI
//       });

//       // App is terminated - check initialMessage
//       RemoteMessage? initialMessage = await _fcm.getInitialMessage();
//       if (initialMessage != null) {
//         print("Notification on app start: ${initialMessage.notification?.title}");
//       }

//     } catch (e) {
//       print("Firebase Messaging init failed: $e");
//     }
//   }
// }
