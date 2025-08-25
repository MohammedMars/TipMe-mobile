// lib/services/notification_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tipme_app/core/storage/storage_service.dart';

class NotificationService {
  static const String _baseUrl = 'http://localhost:5000/api/v1/Notification';

  // first api send notification to all users
  static Future<void> sendBroadcastNotification({
    required String title,
    required String subTitle,
    required String languagePrefix,
    required String tipReceiverId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/Test/broadcast'),
        headers: {
          'Content-Type': 'application/json',
          'accept': '*/*',
        },
        body: json.encode({
          'title': title,
          'subTitle': subTitle,
          'languagePrefix': languagePrefix,
          'tipReceiverId': tipReceiverId,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send broadcast: ${response.statusCode}');
      }
    } catch (e) {
      // if offline save for retry later
      await _storePendingNotification({
        'type': 'broadcast',
        'title': title,
        'subTitle': subTitle,
        'languagePrefix': languagePrefix,
        'tipReceiverId': tipReceiverId,
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    }
  }

  // send notify to specific user
  static Future<void> sendUserNotification({
    required String userId,
    required String title,
    required String subTitle,
    required String languagePrefix,
    required String tipReceiverId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/Test/sendToUser/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'accept': '*/*',
        },
        body: json.encode({
          'title': title,
          'subTitle': subTitle,
          'languagePrefix': languagePrefix,
          'tipReceiverId': tipReceiverId,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to send user notification: ${response.statusCode}');
      }
    } catch (e) {
      // if offline save for retry later
      await _storePendingNotification({
        'type': 'user',
        'userId': userId,
        'title': title,
        'subTitle': subTitle,
        'languagePrefix': languagePrefix,
        'tipReceiverId': tipReceiverId,
        'timestamp': DateTime.now().toIso8601String(),
      });
      rethrow;
    }
  }

  // get notifications for a user
  static Future<List<Map<String, dynamic>>> getUserNotifications(
      String tipReceiverId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/Test/$tipReceiverId'),
        headers: {'accept': '*/*'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await cacheNotifications(
            List<Map<String, dynamic>>.from(data['data'] ?? []), tipReceiverId);
        return List<Map<String, dynamic>>.from(data['data'] ?? []);
      }
      throw Exception('Failed to fetch notifications: ${response.statusCode}');
    } catch (e) {
      return await _getCachedNotifications(tipReceiverId);
    }
  }

  // get grouped notifications
  static Future<List<Map<String, dynamic>>> getGroupedNotifications(
      String tipReceiverId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/Test/Grouped/$tipReceiverId'),
        headers: {'accept': '*/*'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await cacheGroupedNotifications(
            List<Map<String, dynamic>>.from(data['data'] ?? []), tipReceiverId);
        return List<Map<String, dynamic>>.from(data['data'] ?? []);
      }
      throw Exception(
          'Failed to fetch grouped notifications: ${response.statusCode}');
    } catch (e) {
      return await _getCachedGroupedNotifications(tipReceiverId);
    }
  }

  // save notification locally when offline
  static Future<void> _storePendingNotification(
      Map<String, dynamic> notification) async {
    final pending = await StorageService.getList('pending_notifications') ?? [];
    pending.add(notification);
    await StorageService.setList('pending_notifications', pending);
  }

  // retry sending pending notifications when back online
  static Future<void> retryPendingNotifications() async {
    final pending = await StorageService.getList('pending_notifications') ?? [];

    for (final notification in List<Map<String, dynamic>>.from(pending)) {
      try {
        if (notification['type'] == 'broadcast') {
          await sendBroadcastNotification(
            title: notification['title'],
            subTitle: notification['subTitle'],
            languagePrefix: notification['languagePrefix'],
            tipReceiverId: notification['tipReceiverId'],
          );
        } else if (notification['type'] == 'user') {
          await sendUserNotification(
            userId: notification['userId'],
            title: notification['title'],
            subTitle: notification['subTitle'],
            languagePrefix: notification['languagePrefix'],
            tipReceiverId: notification['tipReceiverId'],
          );
        }

        pending.remove(notification);
        await StorageService.setList('pending_notifications', pending);
      } catch (e) {
        print('Failed to retry notification: $e');
      }
    }
  }

  static Future<void> cacheNotifications(
      List<Map<String, dynamic>> notifications, String tipReceiverId) async {
    await StorageService.setList(
        'cached_notifications_$tipReceiverId', notifications);
  }

  static Future<List<Map<String, dynamic>>> _getCachedNotifications(
      String tipReceiverId) async {
    final cached =
        await StorageService.getList('cached_notifications_$tipReceiverId');
    return List<Map<String, dynamic>>.from(cached);
  }

  static Future<void> cacheGroupedNotifications(
      List<Map<String, dynamic>> notifications, String tipReceiverId) async {
    await StorageService.setList(
        'cached_grouped_notifications_$tipReceiverId', notifications);
  }

  static Future<List<Map<String, dynamic>>> _getCachedGroupedNotifications(
      String tipReceiverId) async {
    final cached = await StorageService.getList(
        'cached_grouped_notifications_$tipReceiverId');
    return List<Map<String, dynamic>>.from(cached);
  }
}
