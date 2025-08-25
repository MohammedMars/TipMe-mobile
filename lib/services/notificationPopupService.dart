import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart' as overlay;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tipme_app/viewModels/notificationDataModel.dart';
import 'package:tipme_app/utils/colors.dart';
import 'package:tipme_app/utils/app_font.dart';

class NotificationPopupService {
  static NotificationPopupService? _instance;
  static NotificationPopupService get instance => _instance ??= NotificationPopupService._();
  
  NotificationPopupService._();

  void showNotificationPopup(NotificationDataModel notification) {
    overlay.showOverlayNotification(
      (context) => _buildNotificationCard(context, notification),
      duration: const Duration(seconds: 4),
      position: overlay.NotificationPosition.top,
    );
  }

  void showSimpleToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
      backgroundColor: AppColors.secondary,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Widget _buildNotificationCard(BuildContext context, NotificationDataModel notification) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [AppColors.secondary, AppColors.secondary.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.notifications_active,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    notification.title ?? 'New Notification',
                    style: AppFonts.mdBold(context, color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.subtitle ?? 'You have a new notification',
                    style: AppFonts.smRegular(context, color: Colors.white.withOpacity(0.9)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(notification.createdAt),
                    style: AppFonts.xsRegular(context, color: Colors.white.withOpacity(0.7)),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => overlay.OverlaySupportEntry.of(context)?.dismiss(),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return 'Now';
    
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }

  void showTipReceivedPopup(NotificationDataModel notification) {
    overlay.showOverlayNotification(
      (context) => _buildTipNotificationCard(context, notification),
      duration: const Duration(seconds: 5),
      position: overlay.NotificationPosition.top,
    );
  }

  Widget _buildTipNotificationCard(BuildContext context, NotificationDataModel notification) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [Colors.green, Colors.teal],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.monetization_on,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '💰 ${notification.title ?? 'Tip Received!'}',
                    style: AppFonts.mdBold(context, color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.subtitle ?? 'You received a new tip!',
                    style: AppFonts.smRegular(context, color: Colors.white.withOpacity(0.9)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => overlay.OverlaySupportEntry.of(context)?.dismiss(),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
