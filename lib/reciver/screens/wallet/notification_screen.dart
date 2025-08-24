//lib\reciver\auth\screens\wallet\notification_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipme_app/reciver/widgets/wallet_widgets/notification_card.dart';
import 'package:tipme_app/reciver/widgets/wallet_widgets/custom_top_bar.dart';
import 'package:tipme_app/data/services/language_service.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/utils/colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Move notifications to instance variable to maintain state
  List<NotificationItem>? _notifications;

  List<NotificationItem> _initializeNotifications(
      LanguageService languageService) {
    return [
      NotificationItem(
        id: '1',
        title: languageService
            .getText('newTipReceived')
            .replaceAll('{amount}', 'SAR 10'),
        subtitle: '',
        time: '2${languageService.getText('minutes')}',
        isRead: false,
        category: 'today',
      ),
      NotificationItem(
        id: '2',
        title: languageService
            .getText('tippedTo')
            .replaceAll('{amount}', 'SAR 20')
            .replaceAll('{name}', 'john doe'),
        subtitle: '',
        time: '2${languageService.getText('minutes')}',
        isRead: false,
        category: 'today',
      ),
      NotificationItem(
        id: '3',
        title: languageService.getText('withdrawalCompleted'),
        subtitle: languageService
            .getText('withdrawalSuccess')
            .replaceAll('{amount}', 'SAR 1,200'),
        time: '10${languageService.getText('minutes')}',
        isRead: true,
        category: 'today',
      ),
      NotificationItem(
        id: '4',
        title: languageService.getText('bankAccountLinked'),
        subtitle: languageService
            .getText('bankAccountLinkedSuccess')
            .replaceAll('{bankName}', 'ABCD'),
        time: '15${languageService.getText('minutes')}',
        isRead: false,
        category: 'yesterday',
      ),
      NotificationItem(
        id: '5',
        title: languageService.getText('withdrawalCompleted'),
        subtitle: languageService
            .getText('withdrawalSuccess')
            .replaceAll('{amount}', 'SAR 500'),
        time: '10${languageService.getText('minutes')}',
        isRead: true,
        category: 'yesterday',
      ),
      NotificationItem(
        id: '6',
        title: languageService
            .getText('newTipReceived')
            .replaceAll('{amount}', 'SAR 5'),
        subtitle: '',
        time: '2${languageService.getText('minutes')}',
        isRead: true,
        category: 'yesterday',
      ),
      NotificationItem(
        id: '7',
        title: languageService
            .getText('newTipReceived')
            .replaceAll('{amount}', 'SAR 10'),
        subtitle: '',
        time: '2${languageService.getText('minutes')}',
        isRead: true,
        category: 'friday',
      ),
      NotificationItem(
        id: '8',
        title: languageService.getText('withdrawalCompleted'),
        subtitle: languageService
            .getText('withdrawalSuccess')
            .replaceAll('{amount}', 'SAR 1,000'),
        time: '10${languageService.getText('minutes')}',
        isRead: true,
        category: 'friday',
      ),
    ];
  }

  void _markAsRead(String notificationId) {
    setState(() {
      final index = _notifications!.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        _notifications![index] = _notifications![index].copyWith(isRead: true);
      }
    });
  }

  List<NotificationItem> _getNotificationsByCategory(String category) {
    return _notifications!.where((n) => n.category == category).toList();
  }

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    // Initialize notifications only once
    _notifications ??= _initializeNotifications(languageService);

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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildNotificationSection(
                          languageService.getText('today'), 'today'),
                      const SizedBox(height: 16),
                      _buildNotificationSection(
                          languageService.getText('yesterday'), 'yesterday'),
                      const SizedBox(height: 16),
                      _buildNotificationSection(
                          languageService.getText('fridayApril4'), 'friday'),
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
