class NotificationDataModel {
  final String? id;
  final String? title;
  final String? subtitle;
  final DateTime? createdAt;
  final String? categoryDate;
  final bool? isRead;

  NotificationDataModel({
    this.id,
    this.title,
    this.subtitle,
    this.createdAt,
    this.categoryDate,
    this.isRead,
  });

  factory NotificationDataModel.fromJson(Map<String, dynamic> json) {
    return NotificationDataModel(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      createdAt: json['createdAt'] != null 
          ? DateTime.tryParse(json['createdAt']) 
          : null,
      categoryDate: json['categoryDate'],
      isRead: json['isRead'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'createdAt': createdAt?.toIso8601String(),
      'categoryDate': categoryDate,
      'isRead': isRead,
    };
  }
}
