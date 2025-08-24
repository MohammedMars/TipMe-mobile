// lib/models/notification_item.dart
import 'package:hive/hive.dart';

part 'notification_item.g.dart';

@HiveType(typeId: 0)
class NotificationItem extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String subtitle;
  @HiveField(3)
  final DateTime timestamp;
  @HiveField(4)
  final bool isRead;
  @HiveField(5)
  final String category;

  NotificationItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.isRead,
    required this.category,
  });

  NotificationItem copyWith({
    String? id,
    String? title,
    String? subtitle,
    DateTime? timestamp,
    bool? isRead,
    String? category,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      category: category ?? this.category,
    );
  }

  factory NotificationItem.fromMap(Map<String, dynamic> map) {
    return NotificationItem(
      id: map['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: map['title'] ?? map['subject'] ?? '',
      subtitle: map['subtitle'] ?? map['subTitle'] ?? map['content'] ?? '',
      timestamp: DateTime.tryParse(map['timestamp'] ?? '') ?? DateTime.now(),
      isRead: map['isRead'] ?? false,
      category: _determineCategory(
          DateTime.tryParse(map['timestamp'] ?? '') ?? DateTime.now()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'category': category,
    };
  }

  String toJson() {
    return '{"id":"$id","title":"$title","subtitle":"$subtitle","timestamp":"${timestamp.toIso8601String()}","isRead":$isRead,"category":"$category"}';
  }

  //  to determine category based on timestamp
  static String _determineCategory(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final notificationDate =
        DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (notificationDate.isAtSameMomentAs(today)) {
      return 'today';
    } else if (notificationDate.isAtSameMomentAs(yesterday)) {
      return 'yesterday';
    } else {
      return 'friday';
    }
  }
}
