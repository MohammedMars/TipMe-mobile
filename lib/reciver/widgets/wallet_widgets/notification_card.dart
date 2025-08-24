//lib\reciver\auth\widgets\wallet_widgets\notification_card.dart
import 'package:flutter/material.dart';
import 'package:tipme_app/utils/colors.dart';
import 'package:tipme_app/utils/app_font.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final bool isRead;
  final VoidCallback? onTap;

  const NotificationCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.time,
    this.isRead = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isRead
              ? AppColors.gray_bg_2
              : AppColors.primary_500.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            if (!isRead)
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
                    title,
                    style: AppFonts.smMedium(
                      context,
                      color: AppColors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
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
              time,
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
