import 'notificationDataModel.dart';

class GroupedNotificationModel {
  final String? categoryDate;
  final List<NotificationDataModel>? notifications;

  GroupedNotificationModel({
    this.categoryDate,
    this.notifications,
  });

  factory GroupedNotificationModel.fromJson(Map<String, dynamic> json) {
    return GroupedNotificationModel(
      categoryDate: json['categoryDate'],
      notifications: json['notifications'] != null
          ? (json['notifications'] as List)
              .map((item) => NotificationDataModel.fromJson(item))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryDate': categoryDate,
      'notifications': notifications?.map((item) => item.toJson()).toList(),
    };
  }
}
