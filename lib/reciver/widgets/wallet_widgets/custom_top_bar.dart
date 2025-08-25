//lib\reciver\auth\widgets\wallet_widgets\custom_top_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tipme_app/utils/colors.dart';

class CustomTopBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? trailing;
  final String? profileImagePath;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;
  final String? notificationIconPath;
  final bool showNotification;
  final bool showProfile;

  const CustomTopBar({
    Key? key,
    this.leading,
    this.title,
    this.trailing,
    this.profileImagePath,
    this.onProfileTap,
    this.onNotificationTap,
    this.notificationIconPath,
    this.showNotification = true,
    this.showProfile = true,
  }) : super(key: key);

  factory CustomTopBar.home({
    Key? key,
    String? profileImagePath,
    VoidCallback? onProfileTap,
    VoidCallback? onNotificationTap,
    String? notificationIconPath,
    bool showNotification = true,
  }) {
    return CustomTopBar(
      key: key,
      profileImagePath: profileImagePath,
      onProfileTap: onProfileTap,
      onNotificationTap: onNotificationTap,
      notificationIconPath: notificationIconPath ?? 'assets/icons/bell.svg',
      showNotification: showNotification,
      showProfile: true,
    );
  }

  factory CustomTopBar.withTitle({
    Key? key,
    required Widget title,
    Widget? leading,
    Widget? trailing,
    bool showNotification = false,
    bool showProfile = false,
    VoidCallback? onNotificationTap,
    String? notificationIconPath,
  }) {
    return CustomTopBar(
      key: key,
      title: title,
      leading: leading,
      trailing: trailing,
      showNotification: showNotification,
      showProfile: showProfile,
      onNotificationTap: onNotificationTap,
      notificationIconPath:
          notificationIconPath ?? 'assets/icons/notification.svg',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (leading != null)
            leading!
          else if (showProfile)
            GestureDetector(
              onTap: onProfileTap,
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  backgroundImage: profileImagePath != null && profileImagePath!.startsWith('http')
                      ? NetworkImage(profileImagePath!) as ImageProvider
                      : profileImagePath != null
                          ? AssetImage(profileImagePath!) as ImageProvider
                          : const AssetImage('assets/images/bank.png') as ImageProvider,
                  onBackgroundImageError: (exception, stackTrace) {
                    // Handle network image errors by falling back to default
                  },
                  child: profileImagePath != null && profileImagePath!.startsWith('http')
                      ? null
                      : null,
                ),
              ),
            )
          else
            const SizedBox(width: 40),
          if (title != null)
            Expanded(
              child: Center(child: title!),
            )
          else
            const Spacer(),
          if (trailing != null)
            trailing!
          else if (showNotification)
            GestureDetector(
              onTap: onNotificationTap,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    notificationIconPath!,
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      AppColors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            )
          else
            const SizedBox(width: 40),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
