// lib/reciver/auth/screens/wallet/notification_screen.dart (updated)
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/core/storage/storage_service.dart';
import 'package:tipme_app/data/services/language_service.dart';
import 'package:tipme_app/reciver/widgets/wallet_widgets/custom_top_bar.dart';
import 'package:tipme_app/reciver/widgets/wallet_widgets/notification_card.dart';
import 'package:tipme_app/services/notification_service.dart';
import 'package:tipme_app/services/notification_hub_service.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/utils/colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationItem> _notifications = [];
  bool _isLoading = true;
  StreamSubscription? _notificationSubscription;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _setupRealTimeNotifications();
  }

  @override
  void dispose() {
    _notificationSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);

    try {
      final userId = await StorageService.get('user_id') ?? 'anonymous';
      final apiNotifications =
          await NotificationService.getUserNotifications(userId);
      final storedNotifications =
          await NotificationHubService.getStoredNotifications();
      final allNotifications = [...apiNotifications, ...storedNotifications];

      _notifications = allNotifications
          .map((n) => NotificationItem(
                id: n['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
                title: n['title'] ?? 'No Title',
                subtitle: n['subTitle'] ?? n['content'] ?? '',
                time: _formatTime(n['timestamp']),
                isRead: n['isRead'] ?? false,
                category: _getCategory(n['timestamp']),
                // for now it will be categoried based on the time that spend on it
                // يعني اذا صار مارق عليها مثلا يوم تلقائيا بتروح لجاتيجوري امبارح
              ))
          .toList();
    } catch (e) {
      print('Error loading notifications: $e');

      // for now i add this becuase there is no notification data to appear it in the screen as the api return null data
    }

    setState(() => _isLoading = false);
  }

  void _setupRealTimeNotifications() {
    final hubService = NotificationHubService();
    _notificationSubscription =
        hubService.notificationStream.listen((notification) {
      setState(() {
        _notifications.insert(
            0,
            NotificationItem(
              id: notification['id'] ??
                  DateTime.now().millisecondsSinceEpoch.toString(),
              title: notification['title'] ?? 'New Notification',
              subtitle: notification['content'] ?? '',
              time: 'Just now',
              isRead: false,
              category: 'today',
            ));
      });
    });
  }

  String _formatTime(String? timestamp) {
    if (timestamp == null) return 'Unknown time';

    final dateTime = DateTime.parse(timestamp);
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m';
    if (difference.inHours < 24) return '${difference.inHours}h';
    return '${difference.inDays}d';
  }

  String _getCategory(String? timestamp) {
    if (timestamp == null) return 'older';

    final dateTime = DateTime.parse(timestamp);
    final now = DateTime.now();

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return 'today';
    } else if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day - 1) {
      return 'yesterday';
    } else {
      return 'older';
    }
  }

  void _markAsRead(String notificationId) {
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
      }
    });
  }

  List<NotificationItem> _getNotificationsByCategory(String category) {
    return _notifications.where((n) => n.category == category).toList();
  }

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: Column(
          children: [
            CustomTopBar.withTitle(
              title: Text(
                languageService.getText('notifications'),
                style: AppFonts.lgBold(context, color: AppColors.white),
              ),
              leading: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: AppColors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildNotificationSection('Today', 'today'),
                            const SizedBox(height: 16),
                            _buildNotificationSection('Yesterday', 'yesterday'),
                            const SizedBox(height: 16),
                            _buildNotificationSection('Older', 'older'),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSection(String title, String category) {
    final categoryNotifications = _getNotificationsByCategory(category);

    if (categoryNotifications.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppFonts.lgSemiBold(context, color: Colors.black),
        ),
        const SizedBox(height: 16),
        ...categoryNotifications
            .map((notification) => NotificationCard(
                  title: notification.title,
                  subtitle: notification.subtitle,
                  time: notification.time,
                  isRead: notification.isRead,
                  onTap: () => _markAsRead(notification.id),
                ))
            .toList(),
      ],
    );
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String subtitle;
  final String time;
  final bool isRead;
  final String category;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.isRead,
    required this.category,
  });

  NotificationItem copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? time,
    bool? isRead,
    String? category,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      time: time ?? this.time,
      isRead: isRead ?? this.isRead,
      category: category ?? this.category,
    );
  }
}
