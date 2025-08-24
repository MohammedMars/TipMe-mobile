// lib/auth/screens/profile/profile_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tipme_app/core/storage/storage_service.dart';
import 'package:tipme_app/reciver/widgets/mainProfile_widgets/custom_list_card.dart';
import 'package:tipme_app/reciver/widgets/wallet_widgets/custom_top_bar.dart';
import 'package:tipme_app/routs/app_routs.dart';
import 'package:tipme_app/utils/app_font.dart';
import 'package:tipme_app/utils/colors.dart';

class ProfilePage extends StatelessWidget {
  final String? backgroundSvgPath;

  const ProfilePage({
    Key? key,
    this.backgroundSvgPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 280,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.secondary,
              ),
              child: Stack(
                children: [
                  if (backgroundSvgPath != null)
                    Positioned.fill(
                      child: SvgPicture.asset(
                        backgroundSvgPath!,
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.white.withOpacity(0.1),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/bank.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Esther Howard',
                          style: AppFonts.xlBold(
                            context,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Riyadh, Saudi Arabia',
                          style: AppFonts.smMedium(
                            context,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '+966 12 345 6789',
                          style: AppFonts.smMedium(
                            context,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    CustomListCard(
                      title: 'Account Info',
                      subtitle: 'Update your account details',
                      iconPath: 'assets/icons/file-text.svg',
                      iconColor: AppColors.white,
                      iconBackgroundColor: AppColors.primary,
                      backgroundColor: AppColors.white,
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.accountInfo);
                      },
                      borderType: CardBorderType.bottom,
                      borderRadius: 0.0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                      trailingType: TrailingType.arrow,
                    ),
                    CustomListCard(
                      title: 'Login & Security',
                      subtitle: 'Keep your account safe and secure',
                      iconPath: 'assets/icons/shield-lock.svg',
                      iconColor: AppColors.white,
                      iconBackgroundColor: AppColors.primary,
                      backgroundColor: AppColors.white,
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.loginSecurity);
                      },
                      borderType: CardBorderType.bottom,
                      borderRadius: 0.0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                      trailingType: TrailingType.arrow,
                    ),
                    CustomListCard(
                      title: 'Notification Preferences',
                      subtitle: 'Customize your notification settings',
                      iconPath: 'assets/icons/bell-ringing.svg',
                      iconColor: AppColors.white,
                      iconBackgroundColor: AppColors.primary,
                      backgroundColor: AppColors.white,
                      onTap: () {
                        Navigator.pushNamed(
                            context, AppRoutes.notificationPreferences);
                      },
                      borderType: CardBorderType.bottom,
                      borderRadius: 0.0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                      trailingType: TrailingType.arrow,
                    ),
                    CustomListCard(
                      title: 'Help & Support',
                      subtitle: 'Get assistance or report issues',
                      iconPath: 'assets/icons/headphones.svg',
                      iconColor: AppColors.white,
                      iconBackgroundColor: AppColors.primary,
                      backgroundColor: AppColors.white,
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.helpSupport);
                      },
                      borderType: CardBorderType.none,
                      borderRadius: 0.0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                      trailingType: TrailingType.arrow,
                    ),
                    const SizedBox(height: 32),
                    GestureDetector(
                      onTap: () {
                        _showSignOutDialog(context);
                      },
                      child: Text(
                        'Sign Out',
                        style: AppFonts.mdSemiBold(
                          context,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Sign Out',
            style: AppFonts.lgBold(context),
          ),
          content: Text(
            'Are you sure you want to sign out?',
            style: AppFonts.mdRegular(context),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppFonts.mdMedium(context, color: AppColors.text),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();

                try {
                  await StorageService.clear();

                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.signInUp,
                    (route) => false,
                  );
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to sign out. Please try again.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text(
                'Sign Out',
                style: AppFonts.mdMedium(context, color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
