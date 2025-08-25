// lib/reciver/auth/screens/wallet/notification_screen.dart (updated)
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/core/dio/client/dio_client.dart';
import 'package:tipme_app/data/services/language_service.dart';
import 'package:tipme_app/di/gitIt.dart';
import 'package:tipme_app/reciver/widgets/wallet_widgets/custom_top_bar.dart';
import 'package:tipme_app/reciver/widgets/wallet_widgets/notification_card.dart';
import 'package:tipme_app/services/notificationService.dart';
import 'package:tipme_app/viewModels/groupedNotificationModel.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/utils/colors.dart';
import 'package:tipme_app/viewModels/notificationDataModel.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<GroupedNotificationModel> _groupedNotifications = [];
  bool _isLoading = true;
  StreamSubscription? _notificationSubscription;
  late NotificationService _notificationService;

  @override
  void initState() {
    super.initState();
    _notificationService =
        NotificationService(sl<DioClient>(instanceName: 'Notification'));
    _loadGroupedNotifications();
  }

  @override
  void dispose() {
    _notificationSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadGroupedNotifications() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final response = await _notificationService.getAllNotificationsGrouped();

      if (response.success && response.data != null) {
        setState(() {
          _groupedNotifications = response.data!;
          _isLoading = false;
        });
      } else {
        setState(() {
          _groupedNotifications = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading notifications: $e');
      setState(() {
        _groupedNotifications = [];
        _isLoading = false;
      });
    }
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

  List<NotificationDataModel> _getNotificationsByCategory(String category) {
    List<NotificationDataModel> notifications = [];
    
    for (var group in _groupedNotifications) {
      if (group.notifications != null && group.categoryDate == category) {
        notifications.addAll(group.notifications!);
      }
    }
    
    return notifications;
  }

  String _mapCategoryName(String? apiCategory) {
    if (apiCategory == null) return 'older';
    
    final lowerCategory = apiCategory.toLowerCase();
    
    if (lowerCategory == 'today') return 'today';
    if (lowerCategory == 'yesterday') return 'yesterday';
    
    // Any other category (like "23 Agosto 25") maps to "older"
    return 'older';
  }

  void _markAsRead(String notificationId) {
    setState(() {
      for (var group in _groupedNotifications) {
        if (group.notifications != null) {
          final notificationIndex =
              group.notifications!.indexWhere((n) => n.id == notificationId);
          if (notificationIndex != -1) {
            // Note: Since NotificationDataModel fields are final, we would need to create a new instance
            // For now, we'll just refresh the data or implement a proper update mechanism
            break;
          }
        }
      }
    });
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
                    : RefreshIndicator(
                        onRefresh: _loadGroupedNotifications,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ..._groupedNotifications.map((group) {
                                if (group.categoryDate != null && group.notifications != null && group.notifications!.isNotEmpty) {
                                  return Column(
                                    children: [
                                      _buildNotificationSection(group.categoryDate!, group.categoryDate!),
                                      const SizedBox(height: 16),
                                    ],
                                  );
                                }
                                return const SizedBox.shrink();
                              }).toList(),
                            ],
                          ),
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
    final notifications = _getNotificationsByCategory(category);

    if (notifications.isEmpty) {
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
        ...notifications
            .map((notification) => NotificationCard(
                  title: notification.title ?? 'No Title',
                  subtitle: notification.subtitle ?? 'No Content',
                  time: _formatTime(notification.createdAt?.toIso8601String()),
                  isRead: notification.isRead ?? false,
                  onTap: () => _markAsRead(notification.id ?? ''),
                ))
            .toList(),
      ],
    );
  }
}
