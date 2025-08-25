// // lib/services/api_service.dart
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ApiService {
//   static const String baseUrl = 'http://localhost:5000';

//   static Future<List<Map<String, dynamic>>> getMissedNotifications(
//       String userId) async {
//     try {
//       print("Fetching missed notifications for userId: $userId");

//       final response = await http.get(
//         Uri.parse('$baseUrl/api/v1/Notification/Test/$userId'),
//         headers: {
//           'accept': '*/*',
//         },
//       );

//       print("API Response Status: ${response.statusCode}");
//       print("API Response Body: ${response.body}");

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);

//         // Handle API's response format
//         if (responseData['success'] == true && responseData['data'] != null) {
//           final List<dynamic> notifications = responseData['data'];
//           return notifications.cast<Map<String, dynamic>>();
//         } else {
//           print('API returned success: false or no data');
//           return [];
//         }
//       } else {
//         print('Failed to fetch notifications: ${response.statusCode}');
//         return [];
//       }
//     } catch (e) {
//       print('Error fetching missed notifications: $e');
//       return [];
//     }
//   }

//   /// Fetch grouped notifications for a specific user
//   static Future<List<Map<String, dynamic>>> getGroupedNotifications(
//       String userId) async {
//     try {
//       print("Fetching grouped notifications for userId: $userId");

//       final response = await http.get(
//         Uri.parse('$baseUrl/api/v1/Notification/Test/Grouped/$userId'),
//         headers: {
//           'accept': '*/*',
//         },
//       );

//       print("Grouped API Response Status: ${response.statusCode}");
//       print("Grouped API Response Body: ${response.body}");

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);

//         if (responseData['success'] == true && responseData['data'] != null) {
//           final List<dynamic> notifications = responseData['data'];
//           return notifications.cast<Map<String, dynamic>>();
//         } else {
//           print('Grouped API returned success: false or no data');
//           return [];
//         }
//       } else {
//         print('Failed to fetch grouped notifications: ${response.statusCode}');
//         return [];
//       }
//     } catch (e) {
//       print('Error fetching grouped notifications: $e');
//       return [];
//     }
//   }

//   /// Send notification to a specific user
//   static Future<bool> sendNotificationToUser(
//       String userId, Map<String, dynamic> notificationData) async {
//     try {
//       print("Sending notification to user: $userId");
//       print("Notification data: $notificationData");

//       final response = await http.post(
//         Uri.parse('$baseUrl/api/v1/Notification/Test/sendToUser/$userId'),
//         headers: {
//           'accept': '*/*',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode(notificationData),
//       );

//       print("Send notification response status: ${response.statusCode}");
//       print("Send notification response body: ${response.body}");

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print("Notification sent successfully: ${responseData['message']}");
//         return true;
//       } else {
//         print("Failed to send notification: ${response.statusCode}");
//         return false;
//       }
//     } catch (e) {
//       print('Error sending notification: $e');
//       return false;
//     }
//   }

//   /// Broadcast notification to all users
//   static Future<bool> broadcastNotification(
//       Map<String, dynamic> notificationData) async {
//     try {
//       print("Broadcasting notification");
//       print("Notification data: $notificationData");

//       final response = await http.post(
//         Uri.parse('$baseUrl/api/v1/Notification/Test/broadcast'),
//         headers: {
//           'accept': '*/*',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode(notificationData),
//       );

//       print("Broadcast response status: ${response.statusCode}");
//       print("Broadcast response body: ${response.body}");

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print("Broadcast sent successfully: ${responseData['message']}");
//         return true;
//       } else {
//         print("Failed to broadcast notification: ${response.statusCode}");
//         return false;
//       }
//     } catch (e) {
//       print('Error broadcasting notification: $e');
//       return false;
//     }
//   }
// }
