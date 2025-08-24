// lib/reciver/auth/widgets/wallet_widgets/notification_card.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tipme_app/models/notification_item.dart';
import 'package:tipme_app/utils/colors.dart';
import 'package:tipme_app/utils/app_font.dart';

class NotificationCard extends StatefulWidget {
  final NotificationItem notification;
  final VoidCallback? onTap;

  const NotificationCard({
    Key? key,
    required this.notification,
    this.onTap,
  }) : super(key: key);

  @override
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  late Timer _timer;

  String getTimeAgo() {
    final now = DateTime.now();
    final diff = now.difference(widget.notification.timestamp);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays}d ago';
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notif = widget.notification;
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notif.isRead
              ? AppColors.gray_bg_2
              : AppColors.primary_500.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            if (!notif.isRead)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 12),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              )
            else
              const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notif.title,
                    style: AppFonts.smMedium(
                      context,
                      color: AppColors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (notif.subtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      notif.subtitle,
                      style: AppFonts.xsRegular(
                        context,
                        color: const Color(0xFFADB5BD),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            Text(
              getTimeAgo(),
              style: AppFonts.smMedium(
                context,
                color: const Color(0xFFADB5BD),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
